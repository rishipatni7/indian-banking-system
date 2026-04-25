<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome - Bharat Global Bank</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&family=Playfair+Display:ital,wght@0,400;1,600&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { scroll-behavior: smooth; }
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: #0f172a; 
            cursor: pointer;
            overflow: hidden;
        }
        .punchline { font-family: 'Playfair Display', serif; }

        /* ═══ Staggered Entrance Animations ═══ */
        .anim-fade-in { animation: fadeIn 1.2s cubic-bezier(0.16, 1, 0.3, 1) forwards; opacity: 0; }
        .anim-fade-in-d1 { animation: fadeIn 1.2s cubic-bezier(0.16, 1, 0.3, 1) 0.3s forwards; opacity: 0; }
        .anim-fade-in-d2 { animation: fadeIn 1.2s cubic-bezier(0.16, 1, 0.3, 1) 0.6s forwards; opacity: 0; }
        .anim-fade-in-d3 { animation: fadeIn 1.2s cubic-bezier(0.16, 1, 0.3, 1) 1.0s forwards; opacity: 0; }
        .anim-fade-in-d4 { animation: fadeIn 1.2s cubic-bezier(0.16, 1, 0.3, 1) 1.6s forwards; opacity: 0; }

        @keyframes fadeIn { 
            from { opacity: 0; transform: translateY(30px) scale(0.97); } 
            to   { opacity: 1; transform: translateY(0) scale(1); } 
        }

        /* ═══ Floating Orbs Animation ═══ */
        .orb { position: absolute; border-radius: 50%; pointer-events: none; }
        .orb-1 { animation: orbFloat1 8s ease-in-out infinite alternate; }
        .orb-2 { animation: orbFloat2 10s ease-in-out infinite alternate; }
        .orb-3 { animation: orbFloat3 12s ease-in-out infinite alternate; }
        @keyframes orbFloat1 { 0% { transform: translate(0,0) scale(1); } 100% { transform: translate(60px, -40px) scale(1.1); } }
        @keyframes orbFloat2 { 0% { transform: translate(0,0) scale(1); } 100% { transform: translate(-50px, 30px) scale(0.9); } }
        @keyframes orbFloat3 { 0% { transform: translate(0,0) scale(1); } 100% { transform: translate(30px, 50px) scale(1.05); } }

        /* ═══ Pulsing CTA ═══ */
        .cta-pulse { animation: ctaPulse 2.5s ease-in-out infinite; }
        @keyframes ctaPulse { 0%, 100% { opacity: 0.4; } 50% { opacity: 1; } }

        /* ═══ Shimmer Line ═══ */
        .shimmer-line { 
            background: linear-gradient(90deg, transparent, rgba(99,102,241,0.3), transparent);
            background-size: 200% 100%;
            animation: shimmer 3s ease-in-out infinite;
        }
        @keyframes shimmer { 0% { background-position: -200% 0; } 100% { background-position: 200% 0; } }

        /* ═══ Particle Stars ═══ */
        .star { position: absolute; border-radius: 50%; background: white; pointer-events: none; animation: twinkle 3s ease-in-out infinite alternate; }
        @keyframes twinkle { 0% { opacity: 0; transform: scale(0.5); } 50% { opacity: 1; transform: scale(1); } 100% { opacity: 0.2; transform: scale(0.7); } }

        /* ═══ Hover Ripple on Body ═══ */
        body:active::after {
            content: '';
            position: fixed;
            top: 50%; left: 50%;
            width: 10px; height: 10px;
            background: rgba(99,102,241,0.3);
            border-radius: 50%;
            transform: translate(-50%, -50%) scale(0);
            animation: ripple 0.6s ease-out;
        }
        @keyframes ripple { to { transform: translate(-50%, -50%) scale(80); opacity: 0; } }
    </style>
</head>
<body onclick="window.location.href='login.jsp';" class="min-h-screen flex flex-col items-center justify-center relative bg-slate-900 text-slate-200">
    
    <!-- Animated Floating Orbs -->
    <div class="orb orb-1" style="top:-5%; left:-8%; width:700px; height:700px; background: radial-gradient(circle, rgba(79,70,229,0.15) 0%, transparent 70%);"></div>
    <div class="orb orb-2" style="bottom:-10%; right:-8%; width:800px; height:800px; background: radial-gradient(circle, rgba(56,189,248,0.12) 0%, transparent 70%);"></div>
    <div class="orb orb-3" style="top:40%; left:50%; width:500px; height:500px; background: radial-gradient(circle, rgba(168,85,247,0.08) 0%, transparent 70%);"></div>

    <!-- Tiny Star Particles -->
    <div class="star" style="top:12%; left:20%; width:2px; height:2px; animation-delay:0s;"></div>
    <div class="star" style="top:25%; right:15%; width:3px; height:3px; animation-delay:0.5s;"></div>
    <div class="star" style="top:60%; left:10%; width:2px; height:2px; animation-delay:1s;"></div>
    <div class="star" style="top:70%; right:25%; width:2px; height:2px; animation-delay:1.5s;"></div>
    <div class="star" style="top:15%; right:40%; width:1px; height:1px; animation-delay:2s;"></div>
    <div class="star" style="bottom:20%; left:35%; width:2px; height:2px; animation-delay:0.8s;"></div>
    <div class="star" style="top:45%; left:75%; width:3px; height:3px; animation-delay:1.2s;"></div>
    <div class="star" style="bottom:35%; right:10%; width:2px; height:2px; animation-delay:0.3s;"></div>

    <main class="relative z-10 text-center px-4 max-w-4xl mx-auto">
        
        <!-- Badge -->
        <div class="anim-fade-in">
            <span class="inline-block py-1.5 px-5 rounded-full bg-slate-800/60 border border-slate-700/50 text-xs font-semibold text-indigo-400 mb-8 tracking-[0.2em] uppercase shadow-lg shadow-indigo-900/20 hover:bg-slate-700/60 hover:border-indigo-500/30 hover:shadow-indigo-500/20 transition-all duration-500">
                Enterprise Banking Solution
            </span>
        </div>

        <!-- Main Title -->
        <div class="anim-fade-in-d1">
            <h1 class="text-5xl md:text-7xl font-extrabold tracking-tight text-white mb-6 drop-shadow-2xl">
                Bharat Global <span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 via-indigo-400 to-purple-500 bg-[length:200%_auto] animate-[gradientShift_4s_ease-in-out_infinite]">Bank</span>
            </h1>
        </div>

        <!-- Shimmer Divider -->
        <div class="anim-fade-in-d2 mx-auto w-48 h-[1px] shimmer-line mb-8"></div>

        <!-- Punchline -->
        <div class="anim-fade-in-d2">
            <p class="punchline text-2xl md:text-4xl text-slate-300 italic mb-16 leading-relaxed">
                "Empowering Your Tomorrows,<br>Securing Your Todays."
            </p>
        </div>

        <!-- Three Feature Pillars -->
        <div class="anim-fade-in-d3 grid grid-cols-3 gap-8 max-w-md mx-auto mb-20">
            <div class="group text-center">
                <div class="w-12 h-12 mx-auto mb-2 rounded-xl bg-slate-800/50 border border-slate-700/50 flex items-center justify-center group-hover:bg-indigo-600/20 group-hover:border-indigo-500/30 group-hover:scale-110 group-hover:shadow-lg group-hover:shadow-indigo-500/20 transition-all duration-500">
                    <svg class="w-5 h-5 text-slate-500 group-hover:text-indigo-400 transition-colors duration-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/></svg>
                </div>
                <span class="text-[10px] text-slate-600 uppercase tracking-widest group-hover:text-slate-400 transition-colors duration-500">Secure</span>
            </div>
            <div class="group text-center">
                <div class="w-12 h-12 mx-auto mb-2 rounded-xl bg-slate-800/50 border border-slate-700/50 flex items-center justify-center group-hover:bg-emerald-600/20 group-hover:border-emerald-500/30 group-hover:scale-110 group-hover:shadow-lg group-hover:shadow-emerald-500/20 transition-all duration-500">
                    <svg class="w-5 h-5 text-slate-500 group-hover:text-emerald-400 transition-colors duration-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
                </div>
                <span class="text-[10px] text-slate-600 uppercase tracking-widest group-hover:text-slate-400 transition-colors duration-500">Instant</span>
            </div>
            <div class="group text-center">
                <div class="w-12 h-12 mx-auto mb-2 rounded-xl bg-slate-800/50 border border-slate-700/50 flex items-center justify-center group-hover:bg-amber-600/20 group-hover:border-amber-500/30 group-hover:scale-110 group-hover:shadow-lg group-hover:shadow-amber-500/20 transition-all duration-500">
                    <svg class="w-5 h-5 text-slate-500 group-hover:text-amber-400 transition-colors duration-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                </div>
                <span class="text-[10px] text-slate-600 uppercase tracking-widest group-hover:text-slate-400 transition-colors duration-500">Global</span>
            </div>
        </div>

        <!-- CTA -->
        <div class="anim-fade-in-d4 cta-pulse">
            <span class="flex items-center justify-center text-xs font-semibold text-slate-400 tracking-[0.3em] uppercase transition-colors hover:text-indigo-400">
                <span class="w-16 h-[1px] bg-gradient-to-r from-transparent to-slate-600 mr-6"></span>
                Click Anywhere To Enter Secure Portal
                <span class="w-16 h-[1px] bg-gradient-to-l from-transparent to-slate-600 ml-6"></span>
            </span>
        </div>
    </main>

    <style>
        @keyframes gradientShift { 0% { background-position: 0% center; } 50% { background-position: 100% center; } 100% { background-position: 0% center; } }
    </style>
</body>
</html>
