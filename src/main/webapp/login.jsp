<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Bharat Global Bank</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { scroll-behavior: smooth; }
        body { font-family: 'Inter', sans-serif; background-color: #0f172a; }

        .glass {
            background: rgba(30, 41, 59, 0.65);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.08);
        }

        /* ═══ Entrance ═══ */
        .anim-entrance { animation: entrance 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards; opacity: 0; }
        @keyframes entrance { 
            from { opacity: 0; transform: translateY(40px) scale(0.95); filter: blur(4px); } 
            to   { opacity: 1; transform: translateY(0) scale(1); filter: blur(0); } 
        }

        /* ═══ Floating Orbs ═══ */
        .orb { position: absolute; border-radius: 50%; pointer-events: none; }
        .orb-1 { animation: orbDrift1 7s ease-in-out infinite alternate; }
        .orb-2 { animation: orbDrift2 9s ease-in-out infinite alternate; }
        @keyframes orbDrift1 { 0% { transform: translate(0,0); } 100% { transform: translate(40px,-30px); } }
        @keyframes orbDrift2 { 0% { transform: translate(0,0); } 100% { transform: translate(-30px,40px); } }

        /* ═══ Input Focus Glow ═══ */
        .input-glow { transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1); }
        .input-glow:focus {
            border-color: #818cf8;
            box-shadow: 0 0 0 3px rgba(129, 140, 248, 0.15), 0 0 20px rgba(129, 140, 248, 0.1);
            transform: translateY(-1px);
        }

        /* ═══ Button Hover Glow ═══ */
        .btn-glow {
            position: relative;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .btn-glow::before {
            content: '';
            position: absolute;
            top: 0; left: -100%;
            width: 100%; height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.15), transparent);
            transition: left 0.6s ease;
        }
        .btn-glow:hover::before { left: 100%; }
        .btn-glow:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 8px 30px rgba(99,102,241,0.4), 0 0 60px rgba(99,102,241,0.15); 
        }
        .btn-glow:active { transform: translateY(0) scale(0.98); }

        /* ═══ Tab Slider ═══ */
        .tab-btn { transition: all 0.35s cubic-bezier(0.16, 1, 0.3, 1); position: relative; }
        .tab-btn.active { background: linear-gradient(135deg, #4f46e5, #6366f1); box-shadow: 0 4px 15px rgba(79,70,229,0.4); }
        .tab-btn:not(.active):hover { background: rgba(71, 85, 105, 0.3); }

        /* ═══ Link Hover Underline ═══ */
        .link-hover { position: relative; transition: color 0.3s ease; }
        .link-hover::after {
            content: '';
            position: absolute;
            bottom: -2px; left: 50%;
            width: 0; height: 1px;
            background: currentColor;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .link-hover:hover::after { left: 0; width: 100%; }

        /* ═══ Registration Card Hover ═══ */
        .reg-card {
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .reg-card:hover {
            transform: translateY(-2px);
            border-color: rgba(99,102,241,0.4);
            box-shadow: 0 4px 20px rgba(99,102,241,0.15);
            background: rgba(30, 41, 59, 0.8);
        }

        /* ═══ Checkbox Custom ═══ */
        input[type="checkbox"] { transition: all 0.2s ease; }
        input[type="checkbox"]:hover { transform: scale(1.15); }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center relative overflow-hidden bg-slate-900 text-slate-200">
    
    <!-- Floating Animated Orbs -->
    <div class="orb orb-1" style="top:-12%; left:-12%; width:500px; height:500px; background: radial-gradient(circle, rgba(99,102,241,0.12) 0%, transparent 70%);"></div>
    <div class="orb orb-2" style="bottom:-12%; right:-12%; width:600px; height:600px; background: radial-gradient(circle, rgba(56,189,248,0.1) 0%, transparent 70%);"></div>

    <div class="glass p-10 rounded-2xl shadow-2xl w-full max-w-md anim-entrance relative z-10">
        
        <!-- Header -->
        <div class="text-center mb-8">
            <h1 class="text-3xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-blue-400 via-indigo-400 to-purple-400">Bharat Global Bank</h1>
            <p class="text-slate-500 text-sm mt-2 tracking-wide">Secure Enterprise Portal</p>
        </div>

        <!-- Role Toggle Tabs -->
        <div class="flex justify-center mb-6 space-x-1 p-1 bg-slate-800/50 rounded-xl border border-slate-700/50">
            <button type="button" onclick="setLoginMode('USER')" id="tabUser" class="tab-btn active w-1/2 py-2.5 text-sm font-semibold rounded-lg text-white cursor-pointer">Customer</button>
            <button type="button" onclick="setLoginMode('ADMIN')" id="tabAdmin" class="tab-btn w-1/2 py-2.5 text-sm font-semibold rounded-lg text-slate-400 cursor-pointer">Admin Portal</button>
        </div>

        <form id="loginForm" action="LoginServlet" method="POST" class="space-y-5">
            
            <script>
                function setLoginMode(mode) {
                    const userTab = document.getElementById('tabUser');
                    const adminTab = document.getElementById('tabAdmin');
                    const usernameInput = document.getElementById('usernameInput');
                    const passwordInput = document.getElementById('passwordInput');
                    const titleText = document.getElementById('modeTitle');
                    const modeIcon = document.getElementById('modeIcon');
                    
                    if (mode === 'ADMIN') {
                        adminTab.classList.add('active', 'text-white');
                        adminTab.classList.remove('text-slate-400');
                        userTab.classList.remove('active', 'text-white');
                        userTab.classList.add('text-slate-400');
                        
                        titleText.innerText = "Admin Subsystem ID";
                        modeIcon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/>';
                        usernameInput.value = 'admin';
                        passwordInput.value = 'admin123';
                    } else {
                        userTab.classList.add('active', 'text-white');
                        userTab.classList.remove('text-slate-400');
                        adminTab.classList.remove('active', 'text-white');
                        adminTab.classList.add('text-slate-400');
                        
                        titleText.innerText = "Username / Account No";
                        modeIcon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>';
                        usernameInput.value = '';
                        passwordInput.value = '';
                    }
                }
            </script>

            <div>
                <label id="modeTitle" class="flex items-center text-sm font-medium text-slate-300 mb-1.5">
                    <svg id="modeIcon" class="w-4 h-4 mr-2 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>
                    Username / Account No
                </label>
                <input type="text" id="usernameInput" name="username" required 
                    class="input-glow w-full px-4 py-3 bg-slate-800/80 border border-slate-700 rounded-xl focus:outline-none text-slate-100 placeholder-slate-500" placeholder="Enter your credentials">
            </div>

            <div>
                <label class="flex items-center text-sm font-medium text-slate-300 mb-1.5">
                    <svg class="w-4 h-4 mr-2 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/></svg>
                    Password
                </label>
                <input type="password" id="passwordInput" name="password" required 
                    class="input-glow w-full px-4 py-3 bg-slate-800/80 border border-slate-700 rounded-xl focus:outline-none text-slate-100 placeholder-slate-500" placeholder="Enter your password">
            </div>

            <div class="flex items-center justify-between text-sm">
                <label class="flex items-center text-slate-400 cursor-pointer hover:text-slate-300 transition-colors">
                    <input type="checkbox" class="mr-2 rounded border-slate-700 bg-slate-800 text-indigo-500 focus:ring-indigo-500 cursor-pointer"> Remember me
                </label>
                <a href="#" class="link-hover text-indigo-400 hover:text-indigo-300">Forgot password?</a>
            </div>

            <button type="submit" class="btn-glow w-full py-3.5 px-4 bg-gradient-to-r from-indigo-600 to-blue-600 text-white font-semibold rounded-xl shadow-lg cursor-pointer focus:outline-none">
                Secure Login
            </button>
        </form>
        
        <div class="mt-6 text-center border-t border-slate-700/50 pt-6">
            <p class="text-slate-500 text-sm mb-3">Don't have an account?</p>
            <a href="register.jsp" class="reg-card inline-block w-full py-3 px-4 bg-slate-800/60 text-indigo-400 font-semibold rounded-xl border border-indigo-500/20 text-center cursor-pointer">
                New Registration
            </a>
        </div>
    </div>
</body>
</html>