<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>도시 비즈니스 자원 통합 검색 플랫폼 - 결과 페이지</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;800&display=swap" rel="stylesheet">

<style>
    body{
        background: linear-gradient(180deg, #f5f7fb 0%, #eef3f9 100%);
        font-family: 'Noto Sans KR', sans-serif;
        color: #1f2937;
    }

    .page-wrap{
        max-width: 1400px;
        margin: 30px auto;
    }

    .hero-box{
        background: linear-gradient(135deg, #0f172a 0%, #1d4ed8 55%, #60a5fa 100%);
        color: white;
        border-radius: 28px;
        padding: 42px;
        box-shadow: 0 20px 45px rgba(15, 23, 42, 0.18);
        position: relative;
        overflow: hidden;
    }

    .hero-box::after{
        content: "";
        position: absolute;
        top: -60px;
        right: -60px;
        width: 220px;
        height: 220px;
        background: rgba(255,255,255,0.08);
        border-radius: 50%;
    }

    .hero-box::before{
        content: "";
        position: absolute;
        bottom: -80px;
        left: -50px;
        width: 180px;
        height: 180px;
        background: rgba(255,255,255,0.06);
        border-radius: 50%;
    }

    .hero-title{
        font-size: 2rem;
        font-weight: 800;
        margin-bottom: 14px;
        position: relative;
        z-index: 1;
    }

    .hero-desc{
        font-size: 1rem;
        line-height: 1.8;
        color: rgba(255,255,255,0.9);
        position: relative;
        z-index: 1;
    }

    .hero-tags{
        position: relative;
        z-index: 1;
    }

    .soft-tag{
        display: inline-block;
        background: rgba(255,255,255,0.16);
        border: 1px solid rgba(255,255,255,0.15);
        color: #fff;
        padding: 9px 14px;
        border-radius: 999px;
        font-size: 0.9rem;
        margin: 6px 6px 0 0;
        backdrop-filter: blur(6px);
    }

    .btn-hero{
        background: #ffffff;
        color: #0f172a;
        font-weight: 700;
        border-radius: 14px;
        padding: 12px 20px;
        border: none;
        box-shadow: 0 8px 20px rgba(0,0,0,0.12);
    }

    .btn-hero:hover{
        background: #f8fafc;
        color: #0f172a;
    }

    .stat-card{
        border: none;
        border-radius: 24px;
        padding: 24px;
        color: white;
        min-height: 150px;
        box-shadow: 0 14px 28px rgba(15, 23, 42, 0.10);
        transition: transform 0.2s ease;
    }

    .stat-card:hover{
        transform: translateY(-4px);
    }

    .stat1{ background: linear-gradient(135deg, #2563eb, #60a5fa); }
    .stat2{ background: linear-gradient(135deg, #059669, #34d399); }
    .stat3{ background: linear-gradient(135deg, #ea580c, #fb923c); }
    .stat4{ background: linear-gradient(135deg, #7c3aed, #a78bfa); }

    .stat-label{
        font-size: 0.95rem;
        opacity: 0.95;
    }

    .stat-value{
        font-size: 2rem;
        font-weight: 800;
        margin: 10px 0 6px;
    }

    .stat-desc{
        font-size: 0.92rem;
        opacity: 0.95;
    }

    .card-modern{
        border: none;
        border-radius: 26px;
        background: rgba(255,255,255,0.94);
        box-shadow: 0 14px 35px rgba(15, 23, 42, 0.08);
        overflow: hidden;
    }

    .card-modern .card-body{
        padding: 28px;
    }

    .section-title{
        font-size: 1.2rem;
        font-weight: 800;
        color: #0f172a;
        margin-bottom: 18px;
    }

    .section-sub{
        color: #64748b;
        font-size: 0.95rem;
        margin-bottom: 18px;
    }

    .result-row{
        border: 1px solid #eef2f7;
        border-radius: 18px;
        padding: 18px;
        margin-bottom: 14px;
        background: #fff;
        transition: all 0.2s ease;
    }

    .result-row:hover{
        border-color: #dbeafe;
        box-shadow: 0 10px 24px rgba(37, 99, 235, 0.08);
    }

    .result-title{
        font-size: 1.08rem;
        font-weight: 700;
        color: #111827;
        margin-bottom: 6px;
    }

    .result-meta{
        color: #6b7280;
        font-size: 0.92rem;
    }

    .badge-soft-blue{
        background: #eaf2ff;
        color: #2563eb;
        border-radius: 999px;
        padding: 6px 12px;
        font-size: 0.84rem;
        font-weight: 700;
    }

    .badge-soft-green{
        background: #e9fbf3;
        color: #059669;
        border-radius: 999px;
        padding: 6px 12px;
        font-size: 0.84rem;
        font-weight: 700;
    }

    .badge-soft-orange{
        background: #fff2e8;
        color: #ea580c;
        border-radius: 999px;
        padding: 6px 12px;
        font-size: 0.84rem;
        font-weight: 700;
    }

    .btn-main{
        background: linear-gradient(135deg, #2563eb, #3b82f6);
        border: none;
        color: white;
        border-radius: 12px;
        padding: 10px 16px;
        font-weight: 700;
    }

    .btn-main:hover{
        background: linear-gradient(135deg, #1d4ed8, #2563eb);
        color: white;
    }

    .btn-soft{
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        color: #334155;
        border-radius: 12px;
        padding: 10px 16px;
        font-weight: 600;
    }

    .btn-soft:hover{
        background: #f1f5f9;
        color: #0f172a;
    }

    .table-modern thead th{
        background: #f8fbff;
        color: #334155;
        border: none;
        font-weight: 700;
        padding: 15px;
    }

    .table-modern tbody td{
        vertical-align: middle;
        padding: 15px;
        border-color: #f1f5f9;
    }

    .consult-card{
        border: 1px solid #edf2f7;
        border-radius: 20px;
        padding: 20px;
        height: 100%;
        background: linear-gradient(180deg, #ffffff 0%, #fbfdff 100%);
        transition: 0.2s ease;
    }

    .consult-card:hover{
        box-shadow: 0 12px 24px rgba(15, 23, 42, 0.08);
        transform: translateY(-3px);
    }

    .consult-title{
        font-weight: 800;
        font-size: 1.05rem;
        margin-bottom: 10px;
    }

    .map-box{
        width: 100%;
        height: 360px;
        border-radius: 22px;
        background:
            radial-gradient(circle at top right, rgba(96,165,250,0.18), transparent 30%),
            linear-gradient(135deg, #eff6ff 0%, #f8fafc 100%);
        border: 1px dashed #cbd5e1;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
        color: #475569;
        text-align: center;
        padding: 20px;
    }

    .map-box .map-icon{
        font-size: 2.3rem;
        margin-bottom: 10px;
    }

    .side-list li{
        border: none;
        border-bottom: 1px solid #f1f5f9;
        padding: 14px 0;
    }

    .side-list li:last-child{
        border-bottom: none;
    }

    .value-card{
        border-radius: 20px;
        padding: 22px;
        height: 100%;
        background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
        border: 1px solid #edf2f7;
    }

    .value-card h5{
        font-weight: 800;
        margin-bottom: 12px;
        color: #0f172a;
    }

    .value-card p{
        margin-bottom: 0;
        color: #475569;
        line-height: 1.8;
    }

    .small-note{
        color: #64748b;
        font-size: 0.9rem;
    }

    @media (max-width: 768px){
        .hero-box{
            padding: 28px;
        }
        .hero-title{
            font-size: 1.5rem;
        }
    }
</style>
</head>
<body>

<%
    request.setCharacterEncoding("UTF-8");

    String keyword = request.getParameter("keyword");
    if(keyword == null || keyword.trim().equals("")){
        keyword = "창업 공간 / 지원사업 / 컨설팅";
    }

    String userType = request.getParameter("userType");
    if(userType == null || userType.trim().equals("")){
        userType = "예비창업자";
    }

    String region = request.getParameter("region");
    if(region == null || region.trim().equals("")){
        region = "경기도 성남시";
    }
%>

<div class="container-fluid page-wrap">

    <!-- 상단 메인 -->
    <div class="hero-box mb-4">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <div class="hero-title">도시 비즈니스 자원 통합 검색 결과</div>
                <div class="hero-desc">
                    분산된 창업공간, 지원사업, 지원기관, 컨설팅 네트워크 정보를 통합하여
                    고객님께 가장 적합한 비즈니스 자원을 한눈에 보여드립니다.
                    검색 결과와 AI 추천 정보를 기반으로 빠르고 효율적인 의사결정을 지원합니다.
                </div>

                <div class="hero-tags mt-3">
                    <span class="soft-tag">검색어: <%= keyword %></span>
                    <span class="soft-tag">이용자 유형: <%= userType %></span>
                    <span class="soft-tag">지역: <%= region %></span>
                </div>
            </div>
            <div class="col-lg-4 text-lg-end mt-4 mt-lg-0">
                <a href="search.jsp" class="btn btn-hero">다시 검색하기</a>
            </div>
        </div>
    </div>

    <!-- 통계 -->
    <div class="row g-3 mb-4">
        <div class="col-md-6 col-xl-3">
            <div class="stat-card stat1">
                <div class="stat-label">추천 공간</div>
                <div class="stat-value">12개</div>
                <div class="stat-desc">회의실 · 공유오피스 · 창업공간</div>
            </div>
        </div>
        <div class="col-md-6 col-xl-3">
            <div class="stat-card stat2">
                <div class="stat-label">지원사업</div>
                <div class="stat-value">8건</div>
                <div class="stat-desc">지원금 · 교육 · 역량강화 프로그램</div>
            </div>
        </div>
        <div class="col-md-6 col-xl-3">
            <div class="stat-card stat3">
                <div class="stat-label">컨설팅 기업</div>
                <div class="stat-value">15개</div>
                <div class="stat-desc">세무 · 법률 · 경영 · 기술 컨설팅</div>
            </div>
        </div>
        <div class="col-md-6 col-xl-3">
            <div class="stat-card stat4">
                <div class="stat-label">지원기관</div>
                <div class="stat-value">6개</div>
                <div class="stat-desc">창업센터 · 공공기관 · 연계기관</div>
            </div>
        </div>
    </div>

    <div class="row g-4">

        <!-- 왼쪽 -->
        <div class="col-xl-8">

            <!-- 지원사업 -->
            <div class="card card-modern mb-4">
                <div class="card-body">
                    <div class="section-title">1. AI 추천 지원사업</div>
                    <div class="section-sub">고객님의 창업 단계와 지역 조건을 반영하여 활용 가능성이 높은 지원사업을 우선 추천합니다.</div>

                    <div class="result-row">
                        <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
                            <div>
                                <div class="result-title">초기창업패키지 지원사업</div>
                                <div class="result-meta mb-2">
                                    예비창업자 및 초기창업기업 대상 사업화 자금, 멘토링, 교육 지원
                                </div>
                                <span class="badge-soft-blue">기관: 창업진흥원</span>
                                <span class="badge-soft-green">유형: 사업화 자금</span>
                            </div>
                            <div>
                                <button class="btn btn-main">상세보기</button>
                            </div>
                        </div>
                    </div>

                    <div class="result-row">
                        <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
                            <div>
                                <div class="result-title">중소기업 정책자금 지원</div>
                                <div class="result-meta mb-2">
                                    창업기업 운영자금 및 시설자금 지원 프로그램
                                </div>
                                <span class="badge-soft-blue">기관: 중소벤처기업진흥공단</span>
                                <span class="badge-soft-orange">유형: 정책자금</span>
                            </div>
                            <div>
                                <button class="btn btn-soft">신청안내</button>
                            </div>
                        </div>
                    </div>

                    <div class="result-row mb-0">
                        <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
                            <div>
                                <div class="result-title">기술보증 연계 프로그램</div>
                                <div class="result-meta mb-2">
                                    기술 기반 기업 대상 보증, 투자, 신용 지원 연계 서비스
                                </div>
                                <span class="badge-soft-blue">기관: 기술보증기금</span>
                                <span class="badge-soft-green">유형: 보증 · 금융</span>
                            </div>
                            <div>
                                <button class="btn btn-soft">바로가기</button>
                            </div>
                        </div>
                    </div>

                </div>
            </div>

            <!-- 공간 -->
            <div class="card card-modern mb-4">
                <div class="card-body">
                    <div class="section-title">2. 추천 창업 공간 / 회의실</div>
                    <div class="section-sub">예약 가능 여부, 접근성, 시설 편의성, 혼잡 예측 결과를 반영한 공간 추천입니다.</div>

                    <div class="table-responsive">
                        <table class="table table-modern align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>공간명</th>
                                    <th>위치</th>
                                    <th>수용인원</th>
                                    <th>예약 현황</th>
                                    <th>시설 정보</th>
                                    <th>기능</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><strong>성남 스타트업 라운지 A</strong></td>
                                    <td>성남시 분당구</td>
                                    <td>10명</td>
                                    <td><span class="badge text-bg-success">예약 가능</span></td>
                                    <td>빔프로젝터, 와이파이, 주차</td>
                                    <td><button class="btn btn-sm btn-main">예약</button></td>
                                </tr>
                                <tr>
                                    <td><strong>판교 공유오피스 B</strong></td>
                                    <td>성남시 분당구</td>
                                    <td>20명</td>
                                    <td><span class="badge text-bg-warning">대기 2팀</span></td>
                                    <td>회의실, 프린터, 카페존</td>
                                    <td><button class="btn btn-sm btn-soft">상세보기</button></td>
                                </tr>
                                <tr>
                                    <td><strong>수정 창업지원센터 회의실</strong></td>
                                    <td>성남시 수정구</td>
                                    <td>8명</td>
                                    <td><span class="badge text-bg-success">예약 가능</span></td>
                                    <td>모니터, 화상회의, 와이파이</td>
                                    <td><button class="btn btn-sm btn-main">예약</button></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="alert alert-primary mt-4 mb-0 rounded-4 border-0">
                        <strong>AI 수요 예측 결과:</strong>
                        오늘 오후 2시~4시에 특정 공간 수요가 집중될 가능성이 높아,
                        인근 대체 공간을 함께 추천하여 대기 시간을 줄일 수 있도록 설계되었습니다.
                    </div>
                </div>
            </div>

            <!-- 컨설팅 -->
            <div class="card card-modern mb-4">
                <div class="card-body">
                    <div class="section-title">3. 추천 컨설팅 기업 / 전문가</div>
                    <div class="section-sub">고객님의 필요 분야와 전문성 적합도를 바탕으로 우선 추천된 네트워크입니다.</div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="consult-card">
                                <div class="consult-title">세무 전략 파트너스</div>
                                <div class="result-meta mb-2">분야: 세무 / 회계</div>
                                <p class="mb-2">전문성: 스타트업 세무 신고, 정부지원금 정산</p>
                                <p class="mb-3"><strong>매출액:</strong> 12억 원</p>
                                <button class="btn btn-main btn-sm">전문가 연결</button>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="consult-card">
                                <div class="consult-title">법률 비즈니스 컨설팅</div>
                                <div class="result-meta mb-2">분야: 법률 / 계약</div>
                                <p class="mb-2">전문성: 법인 설립, 투자계약, 지식재산권</p>
                                <p class="mb-3"><strong>매출액:</strong> 18억 원</p>
                                <button class="btn btn-main btn-sm">상담 신청</button>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="consult-card">
                                <div class="consult-title">AI 성장전략 연구소</div>
                                <div class="result-meta mb-2">분야: 사업전략 / 디지털전환</div>
                                <p class="mb-2">전문성: 시장 분석, BM 설계, 데이터 전략</p>
                                <p class="mb-3"><strong>매출액:</strong> 25억 원</p>
                                <button class="btn btn-main btn-sm">연결 요청</button>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="consult-card">
                                <div class="consult-title">기술사업화 전문 그룹</div>
                                <div class="result-meta mb-2">분야: 기술사업화 / 인증</div>
                                <p class="mb-2">전문성: 제품 상용화, 인증, 기술평가</p>
                                <p class="mb-3"><strong>매출액:</strong> 9억 원</p>
                                <button class="btn btn-main btn-sm">상담 예약</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 기관 -->
            <div class="card card-modern mb-4">
                <div class="card-body">
                    <div class="section-title">4. 창업 지원 기관 정보</div>
                    <div class="section-sub">공간, 자금, 교육, 투자, 네트워킹을 지원하는 주요 기관을 정리했습니다.</div>

                    <div class="result-row">
                        <div class="result-title">성남 창업지원센터</div>
                        <div class="result-meta">입주공간, 멘토링, 교육 프로그램 운영</div>
                    </div>
                    <div class="result-row">
                        <div class="result-title">경기창조경제혁신센터</div>
                        <div class="result-meta">액셀러레이팅, 투자 연계, 네트워크 행사 지원</div>
                    </div>
                    <div class="result-row">
                        <div class="result-title">중소벤처기업진흥공단</div>
                        <div class="result-meta">정책자금, 수출지원, 기업 진단</div>
                    </div>
                    <div class="result-row mb-0">
                        <div class="result-title">기술보증기금</div>
                        <div class="result-meta">기술보증, 기술평가, 창업금융 지원</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 오른쪽 -->
        <div class="col-xl-4">

            <div class="card card-modern mb-4">
                <div class="card-body">
                    <div class="section-title">5. 위치 / 길안내</div>
                    <div class="map-box">
                        <div class="map-icon">📍</div>
                        <div><strong>지도 API 연동 영역</strong></div>
                        <div class="small-note mt-2">
                            공간 위치, 기관 위치, 이동 경로, 주변 대체 자원 추천 결과를 표시할 수 있습니다.
                        </div>
                    </div>

                    <div class="d-grid gap-2 mt-3">
                        <button class="btn btn-main">길안내 시작</button>
                        <button class="btn btn-soft">주변 공간 다시 추천</button>
                    </div>
                </div>
            </div>

            <div class="card card-modern mb-4">
                <div class="card-body">
                    <div class="section-title">6. 관리자 서비스 요약</div>
                    <ul class="list-group side-list">
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <span>오늘 공간 예약 건수</span>
                            <strong>27건</strong>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <span>컨설팅 예약 건수</span>
                            <strong>14건</strong>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <span>전문가 연결 진행</span>
                            <strong>9건</strong>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <span>역량강화 프로그램 등록</span>
                            <strong>5건</strong>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="card card-modern mb-4">
                <div class="card-body">
                    <div class="section-title">7. AI 추천 근거</div>
                    <div class="section-sub">추천 결과는 다음 기준을 종합적으로 반영하여 생성되었습니다.</div>
                    <ul class="mb-0 ps-3" style="line-height: 2;">
                        <li>현재 지역과의 거리 및 접근성</li>
                        <li>공간 예약 가능 여부와 혼잡도</li>
                        <li>기업 성장 단계와 지원 적합성</li>
                        <li>컨설팅 전문성 및 분야 일치도</li>
                        <li>기관 프로그램 연계 가능성</li>
                    </ul>
                </div>
            </div>

        </div>
    </div>

    <!-- 가치 -->
    <div class="card card-modern mt-4">
        <div class="card-body">
            <div class="section-title">8. 고객님에게 제공하는 가치</div>
            <div class="section-sub">
                본 플랫폼은 고객님이 필요한 자원을 더 빠르고 정확하게 탐색하고 연결할 수 있도록 지원합니다.
            </div>

            <div class="row g-3">
                <div class="col-md-4">
                    <div class="value-card">
                        <h5>빠른 자원 탐색</h5>
                        <p>
                            회의실, 오피스, 지원사업, 컨설팅 기업, 지원기관 정보를 한 번에 검색하여
                            필요한 자원을 빠르게 찾을 수 있습니다.
                        </p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="value-card">
                        <h5>맞춤형 추천</h5>
                        <p>
                            고객님의 상황과 수요를 반영한 AI 추천 기능을 통해
                            더 적합한 공간, 프로그램, 전문가를 효율적으로 연결할 수 있습니다.
                        </p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="value-card">
                        <h5>이용 효율 향상</h5>
                        <p>
                            공간 예약 현황과 수요 예측 정보를 제공하여 대기 시간을 줄이고,
                            도시 내 비즈니스 인프라 활용 효율을 높일 수 있습니다.
                        </p>
                    </div>
                </div>
            </div>

            <div class="small-note mt-4">
                본 화면은 도시 비즈니스 자원 통합 검색 플랫폼의 결과 페이지 예시이며,
                실제 서비스에서는 실시간 예약 정보, 지도 연동, 상세 신청 기능이 추가될 수 있습니다.
            </div>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>