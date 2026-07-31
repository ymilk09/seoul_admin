<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SEOUL MY SOUL</title>

  <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>

  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Noto Sans KR', -apple-system, sans-serif;
    }

    body {
      background-color: #f8fafc;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      color: #333;
    }

    /* 메인 카드 컨테이너 */
    .login-card {
      width: 100%;
      max-width: 450px;
      background: #ffffff;
      border-radius: 16px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
      overflow: hidden;
      border: 1px solid #e2e8f0;
    }

    /* 상단 헤더 영역 (교육부 로고) */
    .login-header {
      padding: 24px 30px 18px;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 12px;
      border-bottom: 1px solid #f1f5f9;
    }

    .login-header img {
      height: 20px
    }

    .login-header span {
      font-size: 1.1rem;
      font-weight: 700;
      color: #1e293b;
    }

    /* 로그인 폼 영역 */
    .form-section {
      padding: 30px;
    }

    .form-title {
      font-size: 1.25rem;
      font-weight: 800;
      color: #1e293b;
      margin-bottom: 20px;
      text-align: center;
    }

    /* 입력 필드 */
    .input-group {
      display: flex;
      flex-direction: column;
      gap: 12px;
      margin-bottom: 20px;
    }

    .input-field {
      width: 100%;
      padding: 14px 16px;
      border: 1px solid #cbd5e1;
      border-radius: 8px;
      font-size: 0.95rem;
      outline: none;
      transition: border-color 0.2s;
    }

    .input-field:focus {
      border-color: #2563eb;
      box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
    }

    /* 버튼 스타일 */
    .btn-login {
      width: 100%;
      padding: 15px;
      background-color: #2563eb;
      color: #ffffff;
      border: none;
      border-radius: 8px;
      font-size: 1.05rem;
      font-weight: 700;
      cursor: pointer;
      transition: background-color 0.2s;
    }

    .btn-login:hover {
      background-color: #1d4ed8;
    }

    /* 푸터 가이드 */
    .login-footer {
      padding: 18px 30px 24px;
      font-size: 0.8rem;
      color: #64748b;
      text-align: center;
      border-top: 1px solid #f1f5f9;
      background-color: #fafafa;
    }
  </style>
</head>
<body>

  <div class="login-card">
    <div class="login-header">
      <img src="home.png" alt="SEOUL MY SOUL" onerror="this.style.display='none';">
    </div>

    <div class="form-section">
      <div class="form-title"></div>

      <form id="id-login-form" onsubmit="handleLogin(event)">
        <div class="input-group">
          <input type="text" id="user-id" class="input-field" placeholder="아이디를 입력하세요" autocomplete="username" required>
          <input type="password" id="user-pw" class="input-field" placeholder="비밀번호를 입력하세요" autocomplete="current-password" required>
        </div>
        <button type="submit" class="btn-login">로그인</button>
      </form>
    </div>

    <div class="login-footer">
      ※ 승인된 사용자만 접근할 수 있습니다.
    </div>
  </div>

<script>
  /* 🔑 1. Supabase 설정 */
  const SUPABASE_URL = 'https://arwwkmoeypsuzayrgkjd.supabase.co';
  const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFyd3drbW9leXBzdXpheXJna2pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODUzMjIyMTAsImV4cCI6MjEwMDg5ODIxMH0.sbfZXyCgQJli_6hUGMv2xtNwCB5aEWjReMyrngFT-F4';
  
  const supabaseClient = window.supabase ? window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY) : null;

  /* 🔑 2. 로그인 처리 (새로고침 차단 반영) */
  async function handleLogin(e) {
    // 폼 제출에 의한 페이지 새로고침 방지
    if (e) {
      e.preventDefault();
      e.stopPropagation();
    }

    const userId = document.getElementById('user-id').value.trim();
    const password = document.getElementById('user-pw').value.trim();

    if (!userId || !password) {
      alert('아이디와 비밀번호를 모두 입력해주세요.');
      return false;
    }

    try {
      if (supabaseClient) {
        // Supabase users 테이블 조회
        const { data: users, error } = await supabaseClient
          .from('users')
          .select('*')
          .eq('id', userId)
          .eq('password', password);

        if (error) throw error;

        if (users && users.length > 0) {
          const loggedUser = users[0];
          sessionStorage.setItem('currentUser', JSON.stringify({
            id: loggedUser.id,
            name: loggedUser.name,
            dept: loggedUser.dept
          }));

          alert(`${loggedUser.name}님 환영합니다!`);
          location.href = 'index.html';
          return false;
        }
      }

      // DB 미연동 시 테스트용 계정
      if (userId === 'lim2 && password === '1234') {
        sessionStorage.setItem('currentUser', JSON.stringify({
          id: 'lim.2', name: '김대표', dept: '대표실'
        }));
        alert('로그인 성공!');
        location.href = 'approval.html';
      } else {
        alert('아이디 또는 비밀번호가 일치하지 않습니다.');
      }

    } catch (err) {
      console.error('로그인 오류:', err);
      alert('로그인 처리 중 오류가 발생했습니다.');
    }

    return false;
  }
</script>
</body>
</html>	
