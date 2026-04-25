<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Registration Form - Bharat Global Bank</title>
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
            from { opacity: 0; transform: translateY(40px) scale(0.97); filter: blur(3px); } 
            to   { opacity: 1; transform: translateY(0) scale(1); filter: blur(0); } 
        }

        /* ═══ Section Stagger ═══ */
        .section-stagger { opacity: 0; animation: sectionIn 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .section-stagger:nth-child(1) { animation-delay: 0.1s; }
        .section-stagger:nth-child(2) { animation-delay: 0.2s; }
        .section-stagger:nth-child(3) { animation-delay: 0.3s; }
        .section-stagger:nth-child(4) { animation-delay: 0.4s; }
        .section-stagger:nth-child(5) { animation-delay: 0.5s; }
        @keyframes sectionIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        /* ═══ Input Animations ═══ */
        .input-box {
            width: 100%;
            padding: 0.7rem 1rem;
            background-color: rgba(30, 41, 59, 0.8);
            border: 1px solid #334155;
            border-radius: 0.75rem;
            color: #f1f5f9;
            font-size: 0.875rem;
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .input-box:hover {
            border-color: #475569;
            background-color: rgba(30, 41, 59, 0.95);
        }
        .input-box:focus {
            outline: none;
            border-color: #10b981;
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.15), 0 0 25px rgba(16, 185, 129, 0.08);
            transform: translateY(-1px);
        }

        .form-label {
            display: block;
            font-size: 0.7rem;
            font-weight: 600;
            color: #94a3b8;
            margin-bottom: 0.35rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            transition: color 0.3s ease;
        }
        .input-box:focus + .form-label, 
        div:focus-within > .form-label { color: #10b981; }

        /* ═══ Floating Orbs ═══ */
        .orb { position: fixed; border-radius: 50%; pointer-events: none; z-index: 0; }
        .orb-1 { animation: orbFloat1 8s ease-in-out infinite alternate; }
        .orb-2 { animation: orbFloat2 10s ease-in-out infinite alternate; }
        @keyframes orbFloat1 { 0% { transform: translate(0,0) scale(1); } 100% { transform: translate(50px,-40px) scale(1.1); } }
        @keyframes orbFloat2 { 0% { transform: translate(0,0) scale(1); } 100% { transform: translate(-40px,50px) scale(0.9); } }

        /* ═══ Submit Button ═══ */
        .btn-submit {
            position: relative;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .btn-submit::before {
            content: '';
            position: absolute;
            top: 0; left: -100%;
            width: 100%; height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.15), transparent);
            transition: left 0.6s ease;
        }
        .btn-submit:hover::before { left: 100%; }
        .btn-submit:hover { 
            transform: translateY(-3px); 
            box-shadow: 0 10px 40px rgba(16,185,129,0.35), 0 0 60px rgba(16,185,129,0.12); 
        }
        .btn-submit:active { transform: translateY(0) scale(0.98); }

        /* ═══ Section Card Hover ═══ */
        .form-section {
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            border: 1px solid transparent;
            border-radius: 0.75rem;
            padding: 1.5rem;
        }
        .form-section:hover {
            background: rgba(30, 41, 59, 0.3);
            border-color: rgba(148, 163, 184, 0.1);
        }

        /* ═══ Radio Styled ═══ */
        .radio-card {
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            padding: 0.5rem 1rem;
            border: 1px solid #334155;
            border-radius: 0.5rem;
            cursor: pointer;
        }
        .radio-card:hover { background: rgba(30,41,59,0.8); border-color: #475569; }
        .radio-card:has(input:checked) { border-color: #10b981; background: rgba(16,185,129,0.08); box-shadow: 0 0 15px rgba(16,185,129,0.1); }

        /* ═══ Scroll Progress Bar ═══ */
        .scroll-progress {
            position: fixed;
            top: 0; left: 0;
            height: 3px;
            background: linear-gradient(90deg, #10b981, #06b6d4);
            z-index: 9999;
            transition: width 0.1s linear;
            box-shadow: 0 0 10px rgba(16,185,129,0.5);
        }

        /* ═══ Custom Scrollbar ═══ */
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #334155; border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background: #475569; }

        /* ═══ Back Link ═══ */
        .back-link { transition: all 0.3s ease; }
        .back-link:hover { color: white; transform: translateX(-4px); }
    </style>
</head>
<body class="min-h-screen py-12 px-4 relative overflow-x-hidden bg-slate-900 text-slate-200">
    
    <!-- Scroll Progress Indicator -->
    <div class="scroll-progress" id="scrollProgress" style="width: 0%;"></div>

    <!-- Floating Orbs -->
    <div class="orb orb-1" style="top:-5%; right:-5%; width:700px; height:700px; background: radial-gradient(circle, rgba(16,185,129,0.1) 0%, transparent 70%);"></div>
    <div class="orb orb-2" style="bottom:-5%; left:-5%; width:700px; height:700px; background: radial-gradient(circle, rgba(99,102,241,0.08) 0%, transparent 70%);"></div>

    <div class="max-w-4xl mx-auto glass rounded-2xl shadow-2xl overflow-hidden anim-entrance relative z-10">
        
        <!-- Header Banner -->
        <div class="bg-gradient-to-r from-emerald-800 to-teal-800 p-8 text-center border-b border-emerald-600/30 relative overflow-hidden">
            <div class="absolute inset-0 bg-[radial-gradient(circle_at_30%_50%,rgba(255,255,255,0.05),transparent_70%)]"></div>
            <h1 class="text-3xl font-bold text-white tracking-tight relative z-10">Account Registration Form</h1>
            <p class="text-emerald-200 text-sm mt-2 font-medium relative z-10">Bharat Global Bank • Secure Onboarding via Staging Pipeline</p>
        </div>

        <form action="RegisterServlet" method="POST" class="p-8 space-y-6">
            
            <!-- System Credentials Section -->
            <div class="section-stagger form-section bg-slate-800/30 border-slate-700/40">
                <h2 class="text-lg font-semibold text-white mb-5 border-b border-slate-700/50 pb-3 flex items-center">
                    <svg class="w-5 h-5 mr-2 text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z"/></svg>
                    Digital Portal Credentials
                </h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label class="form-label">Desired Username</label>
                        <input type="text" name="username" required class="input-box" placeholder="e.g. rahul.sharma88">
                    </div>
                    <div>
                        <label class="form-label">Secure Password</label>
                        <input type="password" name="password" required class="input-box" placeholder="••••••••">
                    </div>
                </div>
            </div>

            <!-- Personal Information -->
            <div class="section-stagger form-section">
                <h2 class="text-lg font-semibold text-white mb-5 border-b border-slate-700/50 pb-3 flex items-center">
                    <svg class="w-5 h-5 mr-2 text-blue-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>
                    Personal Information
                </h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label class="form-label">Full Legal Name</label>
                        <input type="text" name="full_name" required class="input-box" placeholder="As per official documents">
                    </div>
                    <div>
                        <label class="form-label">Date of Birth</label>
                        <input type="date" name="dob" required class="input-box" style="color-scheme: dark;">
                    </div>
                    <div>
                        <label class="form-label">Phone Number</label>
                        <input type="tel" name="phone" required class="input-box" placeholder="+91 90000 00000">
                    </div>
                    <div>
                        <label class="form-label">Email Address</label>
                        <input type="email" name="email" required class="input-box" placeholder="you@domain.com">
                    </div>
                    <div class="md:col-span-2">
                        <label class="form-label">Full Residential Address</label>
                        <textarea name="address" required rows="2" class="input-box" placeholder="Apt, Street, City, State, PIN"></textarea>
                    </div>
                </div>
            </div>

            <!-- Financial Details -->
            <div class="section-stagger form-section">
                <h2 class="text-lg font-semibold text-white mb-5 border-b border-slate-700/50 pb-3 flex items-center">
                    <svg class="w-5 h-5 mr-2 text-amber-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    Financial Details
                </h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label class="form-label">Preferred Account Type</label>
                        <div class="flex space-x-3 mt-2">
                            <label class="radio-card flex items-center text-sm"><input type="radio" name="account_type" value="SAVINGS" checked class="mr-2 text-emerald-500 bg-slate-800 border-slate-700 focus:ring-emerald-500"> Savings</label>
                            <label class="radio-card flex items-center text-sm"><input type="radio" name="account_type" value="CHECKING" class="mr-2 text-emerald-500 bg-slate-800 border-slate-700 focus:ring-emerald-500"> Checking</label>
                            <label class="radio-card flex items-center text-sm"><input type="radio" name="account_type" value="JOINT" class="mr-2 text-emerald-500 bg-slate-800 border-slate-700 focus:ring-emerald-500"> Joint</label>
                        </div>
                    </div>
                    <div>
                        <label class="form-label">Preferred Currency</label>
                        <div class="flex space-x-3 mt-2">
                            <label class="radio-card flex items-center text-sm"><input type="radio" name="currency" value="INR" checked class="mr-2 text-emerald-500 bg-slate-800 border-slate-700 focus:ring-emerald-500"> INR (₹)</label>
                            <label class="radio-card flex items-center text-sm"><input type="radio" name="currency" value="USD" class="mr-2 text-emerald-500 bg-slate-800 border-slate-700 focus:ring-emerald-500"> USD ($)</label>
                        </div>
                    </div>
                    <div class="md:col-span-2">
                        <label class="form-label">Initial Deposit Amount</label>
                        <input type="number" step="0.01" name="initial_deposit" required class="input-box text-xl font-mono text-emerald-400" placeholder="0.00">
                    </div>
                </div>
            </div>

            <!-- KYC & Employment -->
            <div class="section-stagger form-section">
                <h2 class="text-lg font-semibold text-white mb-5 border-b border-slate-700/50 pb-3 flex items-center">
                    <svg class="w-5 h-5 mr-2 text-purple-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
                    KYC & Employment Document
                </h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label class="form-label">ID Type</label>
                        <select name="id_type" class="input-box cursor-pointer">
                            <option value="AADHAAR">Aadhaar Card</option>
                            <option value="PAN">PAN Card</option>
                            <option value="PASSPORT">Passport</option>
                            <option value="VOTER_ID">Voter ID</option>
                        </select>
                    </div>
                    <div>
                        <label class="form-label">ID Number</label>
                        <input type="text" name="id_number" required class="input-box font-mono" placeholder="XXXX-XXXX-XXXX">
                    </div>
                    <div>
                        <label class="form-label">Occupation</label>
                        <input type="text" name="occupation" required class="input-box" placeholder="e.g. Software Engineer">
                    </div>
                    <div>
                        <label class="form-label">Employer / Business Name</label>
                        <input type="text" name="employer_name" required class="input-box" placeholder="Company Name">
                    </div>
                </div>
            </div>

            <!-- Actions -->
            <div class="section-stagger flex items-center justify-between pt-6 border-t border-slate-700/50">
                <a href="login.jsp" class="back-link inline-flex items-center text-sm text-slate-400">
                    <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                    Back to Login
                </a>
                <button type="submit" class="btn-submit py-3.5 px-8 bg-gradient-to-r from-emerald-600 to-teal-600 text-white font-bold rounded-xl shadow-lg cursor-pointer focus:outline-none">
                    Submit Application for Admin Review
                </button>
            </div>
        </form>
    </div>

    <!-- Scroll Progress Script -->
    <script>
        window.addEventListener('scroll', function() {
            const scrollTop = window.scrollY;
            const docHeight = document.documentElement.scrollHeight - window.innerHeight;
            const progress = docHeight > 0 ? (scrollTop / docHeight) * 100 : 0;
            document.getElementById('scrollProgress').style.width = progress + '%';
        });
    </script>
</body>
</html>
