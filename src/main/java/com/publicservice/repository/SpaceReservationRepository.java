package com.publicservice.repository;

import com.publicservice.entity.SpaceReservation;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface SpaceReservationRepository extends JpaRepository<SpaceReservation, Long> {

    List<SpaceReservation> findByUserIdOrderByCreatedAtDesc(Long userId);

    long countByUserIdAndStatus(Long userId, String status);

    @Query("SELECT r FROM SpaceReservation r WHERE r.spaceId IN " +
           "(SELECT s.spaceId FROM Space s WHERE s.hostId = :hostId) " +
           "ORDER BY r.createdAt DESC")
    List<SpaceReservation> findByHostIdOrderByCreatedAtDesc(@Param("hostId") Long hostId);

    @Query("SELECT COUNT(r) FROM SpaceReservation r WHERE r.spaceId IN " +
           "(SELECT s.spaceId FROM Space s WHERE s.hostId = :hostId) AND r.status = :status")
    long countByHostIdAndStatus(@Param("hostId") Long hostId, @Param("status") String status);

    // 특정 공간·날짜의 유효 예약 목록 (타임라인 표시용)
    @Query("SELECT r FROM SpaceReservation r WHERE r.spaceId = :spaceId AND r.useDate = :useDate " +
           "AND r.status IN ('PENDING', 'APPROVED')")
    List<SpaceReservation> findBookedSlots(@Param("spaceId") Long spaceId,
                                           @Param("useDate") LocalDate useDate);

    // 같은 공간·날짜에서 시간이 겹치는 유효 예약 수 (중복 예약 방지용)
    @Query("SELECT COUNT(r) FROM SpaceReservation r " +
           "WHERE r.spaceId = :spaceId " +
           "AND r.useDate = :useDate " +
           "AND r.status IN ('PENDING', 'APPROVED') " +
           "AND r.startTime < :endTime " +
           "AND r.endTime > :startTime")
    long countOverlapping(@Param("spaceId")   Long spaceId,
                          @Param("useDate")   LocalDate useDate,
                          @Param("startTime") LocalTime startTime,
                          @Param("endTime")   LocalTime endTime);
}
