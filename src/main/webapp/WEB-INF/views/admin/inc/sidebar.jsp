<%@ page contentType="text/html; charset=UTF-8" %>
  <aside class="main-sidebar sidebar-dark-primary elevation-4">

    <!-- Brand Logo: 티켓 아이콘 + TicketHubAdmin (현재 창에서 메인페이지로 이동) -->
    <a href="/" class="brand-link" style="text-align: center; padding: 20px 10px;">
      <span style="font-size: 28px; margin-right: 8px;">🎫</span>
      <span class="brand-text"
        style="font-family: 'Segoe UI', Arial, sans-serif; font-weight: 600; font-size: 18px; letter-spacing: 0.5px;">TicketHubAdmin</span>
    </a>

    <!-- Sidebar -->
    <div class="sidebar">

      <!-- Sidebar Menu -->
      <nav class="mt-2">
        <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">

          <!-- 메인페이지관리 -->
          <li class="nav-item main-banner-item">
            <a href="#" class="nav-link">
              <i class="nav-icon fas fa-home"></i>
              <p>
                메인페이지관리
                <i class="right fas fa-angle-left"></i>
              </p>
            </a>
            <ul class="nav nav-treeview">
              <li class="nav-item" id="menu-main-banner">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>메인배너 관리</p>
                </a>
              </li>
            </ul>
            <ul class="nav nav-treeview">
              <li class="nav-item" id="menu-hot-work">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>인기작 관리</p>
                </a>
              </li>
            </ul>
            <ul class="nav nav-treeview">
              <li class="nav-item" id="menu-opening-work">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>오픈예정 관리</p>
                </a>
              </li>
            </ul>
            <ul class="nav nav-treeview">
              <li class="nav-item" id="menu-genre-ranking">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>장르별 화제작 관리</p>
                </a>
              </li>
            </ul>
            <ul class="nav nav-treeview">
              <li class="nav-item" id="menu-bestreview-work">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>베스트 관람후기 관리</p>
                </a>
              </li>
            </ul>
          </li>

          <!-- 공연상세 -->
          <li class="nav-item menu performance">
            <a href="#" class="nav-link">
              <i class="nav-icon fas fa-theater-masks"></i>
              <p>
                공연상세
                <i class="right fas fa-angle-left"></i>
              </p>
            </a>
            <ul class="nav nav-treeview">
              <li class="nav-item">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>인물 관리</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>장소 관리</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>주최/기획 관리</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>작품 관리</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>회차 관리</p>
                </a>
              </li>
            </ul>
          </li>

          <!-- 회원관리 -->
          <li class="nav-item menu">
            <a href="#" class="nav-link">
              <i class="nav-icon fas fa-users"></i>
              <p>
                회원관리
                <i class="right fas fa-angle-left"></i>
              </p>
            </a>
            <ul class="nav nav-treeview">
              <li class="nav-item">
                <a href="#" class="nav-link" id="menu-members">
                  <i class="far fa-circle nav-icon"></i>
                  <p>회원 목록</p>
                </a>
              </li>
            </ul>
          </li>

          <!-- 좌석관리 -->
          <li class="nav-item menu seat">
            <a href="#" class="nav-link">
              <i class="nav-icon fas fa-chair"></i>
              <p>
                좌석관리
                <i class="right fas fa-angle-left"></i>
              </p>
            </a>
            <ul class="nav nav-treeview">
              <li class="nav-item">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>좌석상태관리</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>좌석등급관리</p>
                </a>
              </li>
            </ul>
          </li>

          <!-- 주문관리 -->
          <li class="nav-item menu">
            <a href="#" class="nav-link">
              <i class="nav-icon fas fa-shopping-cart"></i>
              <p>
                주문관리
                <i class="right fas fa-angle-left"></i>
              </p>
            </a>
            <ul class="nav nav-treeview">
              <li class="nav-item">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>주문정보</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>결제관리</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>취소/반품내역</p>
                </a>
              </li>
            </ul>
          </li>

          <!-- CS관리 -->
          <li class="nav-item menu">
            <a href="#" class="nav-link">
              <i class="nav-icon fas fa-headset"></i>
              <p>
                CS관리
                <i class="right fas fa-angle-left"></i>
              </p>
            </a>
            <ul class="nav nav-treeview">
              <li class="nav-item">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>문의 게시판</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>FAQ</p>
                </a>
              </li>
            </ul>
          </li>
          
        </ul>
      </nav>
    </div>
  </aside>