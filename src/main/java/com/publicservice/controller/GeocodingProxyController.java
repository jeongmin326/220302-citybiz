package com.publicservice.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GeocodingProxyController {

    private final HttpClient httpClient = HttpClient.newHttpClient();
    private final ObjectMapper mapper = new ObjectMapper();

    @GetMapping(value = "/api/geocode", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<String> geocode(@RequestParam("query") String query) {
        try {
            String encoded = URLEncoder.encode(query, StandardCharsets.UTF_8);
            String url = "https://nominatim.openstreetmap.org/search?q=" + encoded + "&format=json&limit=1";

            HttpRequest req = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .header("User-Agent", "CityBizHub/1.0")
                    .header("Accept", "application/json")
                    .GET()
                    .build();

            HttpResponse<String> res = httpClient.send(req, HttpResponse.BodyHandlers.ofString());

            if (res.statusCode() != 200) {
                return ResponseEntity.status(res.statusCode()).body(res.body());
            }

            JsonNode results = mapper.readTree(res.body());
            ArrayNode addresses = mapper.createArrayNode();

            if (results.isArray() && results.size() > 0) {
                JsonNode first = results.get(0);
                ObjectNode addr = mapper.createObjectNode();
                addr.put("y", first.path("lat").asText());
                addr.put("x", first.path("lon").asText());
                addresses.add(addr);
            }

            ObjectNode result = mapper.createObjectNode();
            result.set("addresses", addresses);
            return ResponseEntity.ok(mapper.writeValueAsString(result));

        } catch (Exception e) {
            return ResponseEntity.status(500).body("{\"error\":\"주소 검색 중 오류가 발생했습니다.\"}");
        }
    }
}
