<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - Market Local</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #0F0F0F 0%, #1A1A1A 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-container {
            background-color: #1A1A1A;
            border: 1px solid #2A2A2A;
            border-radius: 16px;
            padding: 48px;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
        }

        .logo-container {
            text-align: center;
            margin-bottom: 32px;
        }

        .logo-icon {
            width: 64px;
            height: 64px;
            background: linear-gradient(135deg, #EF4444, #3B82F6);
            border-radius: 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            color: white;
            margin-bottom: 16px;
        }

        .login-title {
            font-size: 28px;
            font-weight: 700;
            color: #FFFFFF;
            margin-bottom: 8px;
        }

        .login-subtitle {
            font-size: 14px;
            color: #9CA3AF;
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 500;
            color: #FFFFFF;
        }

        .input-wrapper {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #6B7280;
            font-size: 18px;
        }

        .form-control {
            width: 100%;
            padding: 14px 16px 14px 48px;
            background-color: #0F0F0F;
            border: 1px solid #2A2A2A;
            border-radius: 10px;
            color: #FFFFFF;
            font-size: 14px;
            transition: all 0.2s;
        }

        .form-control:focus {
            outline: none;
            border-color: #EF4444;
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
        }

        .form-control::placeholder {
            color: #6B7280;
        }

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .checkbox-wrapper {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .checkbox-wrapper input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        .checkbox-wrapper label {
            font-size: 14px;
            color: #9CA3AF;
            cursor: pointer;
        }

        .forgot-link {
            font-size: 14px;
            color: #EF4444;
            text-decoration: none;
            transition: color 0.2s;
        }

        .forgot-link:hover {
            color: #DC2626;
        }

        .btn-login {
            width: 100%;
            padding: 14px;
            background-color: #EF4444;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-login:hover {
            background-color: #DC2626;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.4);
        }

        .btn-login:disabled {
            background-color: #4B5563;
            cursor: not-allowed;
            transform: none;
        }

        .spinner {
            display: none;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-top-color: white;
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        .btn-login.loading .spinner {
            display: block;
        }

        .btn-login.loading .btn-text {
            display: none;
        }

        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-size: 14px;
            display: none;
        }

        .alert.show {
            display: block;
        }

        .alert-error {
            background-color: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.3);
            color: #EF4444;
        }

        .alert-success {
            background-color: rgba(16, 185, 129, 0.1);
            border: 1px solid rgba(16, 185, 129, 0.3);
            color: #10B981;
        }

        .divider {
            text-align: center;
            margin: 24px 0;
            position: relative;
        }

        .divider::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            width: 100%;
            height: 1px;
            background-color: #2A2A2A;
        }

        .divider-text {
            position: relative;
            background-color: #1A1A1A;
            padding: 0 16px;
            font-size: 13px;
            color: #6B7280;
        }

        @media (max-width: 480px) {
            .login-container {
                padding: 32px 24px;
            }

            .login-title {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo-container">
            <div class="logo-icon">
                <i class="fas fa-shield-halved"></i>
            </div>
            <h1 class="login-title">Admin Panel</h1>
            <p class="login-subtitle">Marketplace Manager</p>
        </div>

        <div id="alert" class="alert"></div>

        <form id="loginForm">
            <div class="form-group">
                <label class="form-label" for="email">Email Address</label>
                <div class="input-wrapper">
                    <i class="fas fa-envelope input-icon"></i>
                    <input 
                        type="email" 
                        id="email" 
                        name="email" 
                        class="form-control" 
                        placeholder="admin@example.com"
                        required
                    >
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <div class="input-wrapper">
                    <i class="fas fa-lock input-icon"></i>
                    <input 
                        type="password" 
                        id="password" 
                        name="password" 
                        class="form-control" 
                        placeholder="Enter your password"
                        required
                    >
                </div>
            </div>

            <div class="form-options">
                <div class="checkbox-wrapper">
                    <input type="checkbox" id="remember" name="remember">
                    <label for="remember">Remember me</label>
                </div>
                <a href="#" class="forgot-link">Forgot password?</a>
            </div>

            <button type="submit" class="btn-login" id="loginBtn">
                <span class="spinner"></span>
                <span class="btn-text">Sign In</span>
            </button>
        </form>
    </div>

    <script>
        const API_BASE_URL = '../admin_api.php';
        const loginForm = document.getElementById('loginForm');
        const loginBtn = document.getElementById('loginBtn');
        const alert = document.getElementById('alert');

        function showAlert(message, type = 'error') {
            alert.className = `alert alert-${type} show`;
            alert.textContent = message;
            setTimeout(() => {
                alert.classList.remove('show');
            }, 5000);
        }

        loginForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            
            loginBtn.classList.add('loading');
            loginBtn.disabled = true;

            try {
                const response = await fetch(API_BASE_URL, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        action: 'login',
                        email: email,
                        password: password
                    })
                });

                const data = await response.json();

                if (data.success) {
                    localStorage.setItem('admin_token', data.token);
                    localStorage.setItem('admin_user', JSON.stringify(data.user));
                    showAlert('Login successful! Redirecting...', 'success');
                    setTimeout(() => {
                        window.location.href = 'index.php';
                    }, 1000);
                } else {
                    showAlert(data.message || 'Invalid credentials. Please try again.');
                }
            } catch (error) {
                console.error('Login error:', error);
                showAlert('Connection error. Please try again.');
            } finally {
                loginBtn.classList.remove('loading');
                loginBtn.disabled = false;
            }
        });
    </script>
</body>
</html>
