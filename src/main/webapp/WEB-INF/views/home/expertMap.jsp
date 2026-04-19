<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<c:if test="${expert.latitude != null and expert.longitude != null}">
    <script type="text/javascript"
            src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=${naverClientId}"></script>
</c:if>

<main class="flex-grow max-w-4xl mx-auto w-full px-4 sm:px-6 lg:px-8 py-10">

    <div id="expertMapData"
         data-lat="${expert.latitude}"
         data-lng="${expert.longitude}"
         data-office="${fn:escapeXml(expert.office)}"
         data-name="${fn:escapeXml(expert.name)}"
         data-expert-type="${fn:escapeXml(expert.expertType)}"
         data-phone="${fn:escapeXml(expert.phone)}"
         hidden></div>

    <div class="flex items-center gap-3 mb-6">
        <a href="/consulting" class="flex items-center gap-1.5 text-sm text-slate-400 hover:text-slate-600 transition-colors">
            <i data-lucide="arrow-left" class="w-4 h-4"></i>목록으로
        </a>
        <span class="text-slate-300">/</span>
        <h1 class="text-lg font-bold text-slate-800"><c:out value="${expert.office}"/></h1>
        <span class="shrink-0 bg-purple-600 text-white text-xs px-2.5 py-0.5 rounded-full">
            <c:out value="${expert.expertType}"/>
        </span>
    </div>

    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 mb-6 grid grid-cols-1 sm:grid-cols-3 gap-4 text-sm">
        <div class="flex items-center gap-2 text-slate-600">
            <i data-lucide="user" class="w-4 h-4 text-slate-400 shrink-0"></i>
            <span><c:out value="${expert.name}"/></span>
        </div>
        <div class="flex items-center gap-2 text-slate-600">
            <i data-lucide="phone" class="w-4 h-4 text-red-400 shrink-0"></i>
            <span><c:out value="${not empty expert.phone ? expert.phone : '연락처 정보 없음'}"/></span>
        </div>
        <div class="flex items-center gap-2 text-slate-600">
            <i data-lucide="map-pin" class="w-4 h-4 text-blue-400 shrink-0"></i>
            <span><c:out value="${not empty expert.address ? expert.address : '주소 정보 없음'}"/></span>
        </div>
    </div>

    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <c:choose>
            <c:when test="${expert.latitude != null and expert.longitude != null}">
                <div id="naverMap" style="width:100%;height:480px;"></div>
            </c:when>
            <c:otherwise>
                <div class="flex flex-col items-center justify-center py-20 text-slate-400">
                    <i data-lucide="map-off" class="w-12 h-12 mb-3"></i>
                    <p class="text-base font-medium text-slate-500">위치 정보가 등록되지 않은 전문가입니다.</p>
                    <p class="text-sm mt-1">전화 또는 주소로 직접 문의해 주세요.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</main>

<c:if test="${expert.latitude != null and expert.longitude != null}">
<script>
(function () {
    if (typeof naver === 'undefined' || typeof naver.maps === 'undefined') {
        document.getElementById('naverMap').innerHTML =
            '<div style="display:flex;flex-direction:column;align-items:center;justify-content:center;height:100%;padding:40px;text-align:center">'
            + '<p style="font-size:14px;font-weight:600;color:#64748b;">지도를 불러올 수 없습니다.</p>'
            + '<p style="font-size:12px;color:#94a3b8;margin-top:6px;">NCP 콘솔에서 Client ID 및 허용 도메인을 확인해 주세요.</p>'
            + '</div>';
        return;
    }

    var d = document.getElementById('expertMapData').dataset;
    var lat = parseFloat(d.lat);
    var lng = parseFloat(d.lng);

    var map = new naver.maps.Map('naverMap', {
        center: new naver.maps.LatLng(lat, lng),
        zoom: 17
    });

    var marker = new naver.maps.Marker({
        position: new naver.maps.LatLng(lat, lng),
        map: map
    });

    var phone = d.phone ? '<div style="font-size:12px;color:#64748b;margin-top:3px;">' + d.phone + '</div>' : '';
    var infowindow = new naver.maps.InfoWindow({
        content: '<div style="padding:12px 16px;font-family:sans-serif;min-width:160px">'
            + '<div style="font-size:13px;font-weight:700;color:#1e293b;margin-bottom:3px;">' + d.office + '</div>'
            + '<div style="font-size:12px;color:#64748b;">' + d.expertType + ' · ' + d.name + '</div>'
            + phone
            + '</div>',
        borderRadius: '12px'
    });

    infowindow.open(map, marker);
}());
</script>
</c:if>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
