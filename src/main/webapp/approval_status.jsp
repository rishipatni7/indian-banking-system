<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Application Status - Bharat Global Bank</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background-color: #0f172a; }
        .glass {
            background: rgba(30, 41, 59, 0.65);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.08);
        }

        /* ═══ Card Entrance ═══ */
        .anim-entrance { animation: entrance 0.9s cubic-bezier(0.16, 1, 0.3, 1) forwards; opacity: 0; }
        @keyframes entrance { 
            from { opacity: 0; transform: translateY(50px) scale(0.92); filter: blur(4px); } 
            to   { opacity: 1; transform: translateY(0) scale(1); filter: blur(0); } 
        }

        /* ═══ Hourglass Spin ═══ */
        .hourglass-spin { animation: hourglassSpin 3s cubic-bezier(0.4, 0, 0.2, 1) infinite; }
        @keyframes hourglassSpin { 
            0%   { transform: rotate(0deg) scale(1); } 
            25%  { transform: rotate(180deg) scale(1.05); } 
            50%  { transform: rotate(180deg) scale(1); } 
            75%  { transform: rotate(360deg) scale(1.05); }
            100% { transform: rotate(360deg) scale(1); } 
        }

        /* ═══ Breathing Ring ═══ */
        .breathing-ring {
            position: absolute;
            inset: -8px;
            border-radius: 50%;
            border: 2px solid rgba(245, 158, 11, 0.15);
            animation: breathe 2.5s ease-in-out infinite;
        }
        @keyframes breathe { 0%, 100% { transform: scale(1); opacity: 0.3; } 50% { transform: scale(1.15); opacity: 0.8; } }

        /* ═══ Status Bar Pulse ═══ */
        .status-bar { position: relative; overflow: hidden; }
        .status-bar::after {
            content: '';
            position: absolute;
            top: 0; left: -100%;
            width: 50%; height: 100%;
            background: linear-gradient(90deg, transparent, rgba(245,158,11,0.08), transparent);
            animation: statusSweep 3s ease-in-out infinite;
        }
        @keyframes statusSweep { 0% { left: -50%; } 100% { left: 150%; } }

        /* ═══ Button ═══ */
        .btn-return {
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .btn-return:hover {
            transform: translateY(-2px);
            border-color: rgba(245,158,11,0.4);
            box-shadow: 0 6px 25px rgba(245,158,11,0.15);
            background: rgba(30, 41, 59, 0.9);
        }
        .btn-return:active { transform: translateY(0) scale(0.98); }

        /* ═══ Floating Orbs ═══ */
        .orb { position: absolute; border-radius: 50%; pointer-events: none; }
        .orb-1 { animation: orbDrift 8s ease-in-out infinite alternate; }
        .orb-2 { animation: orbDrift 10s ease-in-out infinite alternate-reverse; }
        @keyframes orbDrift { 0% { transform: translate(0,0); } 100% { transform: translate(40px,-30px); } }

        /* ═══ Progress Dots ═══ */
        .progress-dot { width: 8px; height: 8px; border-radius: 50%; }
        .dot-active { background: #f59e0b; box-shadow: 0 0 10px rgba(245,158,11,0.5); }
        .dot-pending { background: #334155; }
        .dot-connector { width: 40px; height: 2px; background: #334155; }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center relative overflow-hidden bg-slate-900 text-slate-200">
    
    <div class="orb orb-1" style="top:-10%; right:-10%; width:500px; height:500px; background: radial-gradient(circle, rgba(245,158,11,0.1) 0%, transparent 70%);"></div>
    <div class="orb orb-2" style="bottom:-10%; left:-10%; width:500px; height:500px; background: radial-gradient(circle, rgba(99,102,241,0.08) 0%, transparent 70%);"></div>

    <div class="glass p-12 rounded-2xl shadow-2xl w-full max-w-lg anim-entrance relative z-10 text-center border-t-2 border-amber-500/30">
        
        <!-- Animated Hourglass -->
        <div class="relative mx-auto flex items-center justify-center h-24 w-24 rounded-full bg-amber-500/10 mb-8">
            <div class="breathing-ring"></div>
            <svg class="h-10 w-10 text-amber-400 hourglass-spin" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
        </div>

        <h1 class="text-2xl font-bold text-white mb-2">Application Under Review</h1>
        
        <p class="text-slate-400 mt-4 leading-relaxed text-sm">
            Your KYC dossier and financial application have been securely transmitted to the administrative branch. 
        </p>
        
        <!-- Visual Progress Steps -->
        <div class="flex items-center justify-center mt-8 mb-2">
            <div class="progress-dot dot-active"></div>
            <div class="dot-connector"></div>
            <div class="progress-dot dot-active"></div>
            <div class="dot-connector"></div>
            <div class="progress-dot dot-pending" style="animation: breathe 2s ease-in-out infinite;"></div>
        </div>
        <div class="flex items-center justify-center text-[9px] text-slate-600 uppercase tracking-widest mb-6">
            <span class="w-14 text-center text-amber-400">Submitted</span>
            <span class="w-10"></span>
            <span class="w-14 text-center text-amber-400">Queued</span>
            <span class="w-10"></span>
            <span class="w-14 text-center">Approval</span>
        </div>

        <!-- Status Display -->
        <div class="status-bar bg-slate-800/60 p-4 rounded-xl border border-amber-500/20 w-full text-left">
            <p class="text-[10px] text-amber-300 font-semibold uppercase tracking-[0.15em] mb-1.5">Current Status</p>
            <p class="text-white font-mono text-sm tracking-wide">PENDING ADMIN APPROVAL</p>
        </div>
        
        <p class="text-slate-500 text-xs mt-6 italic leading-relaxed">
            Once authorized by an administrator, you will immediately gain access to the secure portal using your registered credentials.
        </p>

        <div class="mt-8 pt-6 border-t border-slate-700/50">
            <a href="login.jsp" class="btn-return inline-block w-full py-3.5 px-4 bg-slate-800/60 text-amber-400 font-semibold rounded-xl border border-amber-500/20 text-center cursor-pointer">
                Return to Login Portal
            </a>
        </div>
    </div>
</body>
</html>
