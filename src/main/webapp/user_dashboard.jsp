<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="bank" uri="http://com.bankmanage.tags" %>

<%
    if (session.getAttribute("account") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<jsp:useBean id="txnDao" class="com.bankmanage.dao.TransactionDAO" scope="request" />
<jsp:useBean id="acctDao" class="com.bankmanage.dao.AccountDAO" scope="request" />
<c:set var="liveAccount" value="${acctDao.getAccountById(sessionScope.account.accountId)}" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard - Bharat Global Bank</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { scroll-behavior: smooth; }
        body { font-family: 'Inter', sans-serif; background-color: #0f172a; }

        .glass-card {
            background: rgba(30, 41, 59, 0.5);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        /* ═══ Page Entrances ═══ */
        .nav-slide { animation: navSlide 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        @keyframes navSlide { from { transform: translateY(-100%); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

        .anim-entrance { animation: entrance 0.7s cubic-bezier(0.16, 1, 0.3, 1) forwards; opacity: 0; }
        .anim-entrance-d1 { animation: entrance 0.7s cubic-bezier(0.16, 1, 0.3, 1) 0.1s forwards; opacity: 0; }
        .anim-entrance-d2 { animation: entrance 0.7s cubic-bezier(0.16, 1, 0.3, 1) 0.2s forwards; opacity: 0; }
        @keyframes entrance { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }

        /* ═══ Notification Slide ═══ */
        .notif-slide {
            animation: notifIn 0.6s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
            opacity: 0;
        }
        @keyframes notifIn { from { opacity: 0; transform: translateX(-30px); } to { opacity: 1; transform: translateX(0); } }

        /* ═══ Balance Card ═══ */
        .balance-card {
            position: relative;
            overflow: hidden;
            transition: all 0.5s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .balance-card::before {
            content: '';
            position: absolute;
            top: -50%; left: -50%;
            width: 200%; height: 200%;
            background: conic-gradient(transparent, rgba(99,102,241,0.05), transparent, rgba(56,189,248,0.05), transparent);
            animation: rotateBg 8s linear infinite;
        }
        @keyframes rotateBg { to { transform: rotate(360deg); } }
        .balance-card:hover { 
            transform: translateY(-3px); 
            box-shadow: 0 12px 40px rgba(99,102,241,0.15); 
            border-color: rgba(99,102,241,0.2);
        }

        /* ═══ Balance Counter Animation ═══ */
        .balance-value {
            background: linear-gradient(135deg, #ffffff, #e2e8f0);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* ═══ KYC Card ═══ */
        .kyc-card { transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1); }
        .kyc-card:hover { transform: translateY(-3px); box-shadow: 0 8px 30px rgba(0,0,0,0.2); }
        .kyc-icon-ring {
            animation: kycPulse 2.5s ease-in-out infinite;
        }
        @keyframes kycPulse { 0%, 100% { box-shadow: 0 0 0 0 rgba(16,185,129,0.3); } 50% { box-shadow: 0 0 0 12px rgba(16,185,129,0); } }

        /* ═══ Transfer Card ═══ */
        .transfer-card { transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1); }
        .transfer-card:hover { border-color: rgba(99,102,241,0.3); }

        /* ═══ Input Glow ═══ */
        .input-glow { transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1); }
        .input-glow:focus {
            border-color: #818cf8;
            box-shadow: 0 0 0 3px rgba(129, 140, 248, 0.12), 0 0 20px rgba(129, 140, 248, 0.08);
            transform: translateY(-1px);
        }

        /* ═══ Radio Cards ═══ */
        .radio-txn {
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .radio-txn:hover { background: rgba(30,41,59,0.9); border-color: #475569; }
        .radio-txn:has(input:checked) { 
            border-color: #818cf8; 
            background: rgba(99,102,241,0.08); 
            box-shadow: 0 0 15px rgba(99,102,241,0.1);
        }
        .radio-txn:has(input:checked) span { color: #a5b4fc !important; }

        /* ═══ Transfer Button ═══ */
        .btn-transfer {
            position: relative;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .btn-transfer::before {
            content: '';
            position: absolute;
            top: 0; left: -100%;
            width: 100%; height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.12), transparent);
            transition: left 0.6s ease;
        }
        .btn-transfer:hover::before { left: 100%; }
        .btn-transfer:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 8px 30px rgba(99,102,241,0.35); 
        }
        .btn-transfer:active { transform: translateY(0) scale(0.98); }

        /* ═══ Transaction Log ═══ */
        .txn-log-card { transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1); }
        .txn-log-card:hover { border-color: rgba(99,102,241,0.2); }

        .txn-row { transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1); }
        .txn-row:hover { 
            background: rgba(30, 41, 59, 0.6) !important; 
            transform: scale(1.003);
        }

        /* ═══ Logout ═══ */
        .logout-btn { transition: all 0.3s ease; position: relative; }
        .logout-btn::after {
            content: '';
            position: absolute;
            bottom: -2px; left: 50%;
            width: 0; height: 1px;
            background: #f87171;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .logout-btn:hover::after { left: 0; width: 100%; }
        .logout-btn:hover { color: #fca5a5; }

        /* ═══ Scrollbar ═══ */
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #334155; border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background: #475569; }
    </style>
</head>
<body class="min-h-screen text-slate-200 bg-slate-900">
    
    <!-- Navbar -->
    <nav class="glass-card sticky top-0 z-50 border-b border-slate-800 nav-slide">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex items-center justify-between h-16">
                <div class="flex items-center">
                    <span class="text-xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-blue-400 via-indigo-400 to-purple-400">Bharat Global Bank</span>
                </div>
                <div class="flex items-center space-x-4">
                    <span class="text-sm text-slate-400">Welcome, <strong class="text-white">${sessionScope.account.fullName}</strong></span>
                    <span class="text-xs bg-slate-800/80 border border-slate-700 px-2.5 py-1 rounded-lg text-slate-300 font-mono">Acct# ${sessionScope.account.accountId}</span>
                    <form action="LogoutServlet" method="POST">
                        <button type="submit" class="logout-btn text-sm text-red-400 font-medium cursor-pointer">Logout Session</button>
                    </form>
                </div>
            </div>
        </div>
    </nav>

    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        
        <!-- Notifications -->
        <c:if test="${param.status == 'success'}">
            <div class="notif-slide bg-emerald-600/15 border border-emerald-500/40 text-emerald-400 px-5 py-4 rounded-xl mb-6 shadow-lg shadow-emerald-900/20 flex items-center">
                <svg class="w-5 h-5 mr-3 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                <div>
                    <span class="font-bold uppercase tracking-wider block text-[11px] mb-0.5">Transfer Terminal Success</span>
                    <span class="text-sm">Funds precisely transferred into destination ledger!</span>
                </div>
            </div>
        </c:if>
        <c:if test="${param.status == 'error'}">
            <div class="notif-slide bg-red-600/15 border border-red-500/40 text-red-400 px-5 py-4 rounded-xl mb-6 shadow-lg shadow-red-900/20 flex items-center">
                <svg class="w-5 h-5 mr-3 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                <div>
                    <span class="font-bold uppercase tracking-wider block text-[11px] mb-0.5">Central Banking Block</span>
                    <span class="text-sm"><c:out value="${param.message}"/></span>
                </div>
            </div>
        </c:if>

        <!-- Balance + KYC Row -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8 anim-entrance">
            
            <!-- Balance Card -->
            <div class="balance-card glass-card rounded-2xl p-7 md:col-span-2 shadow-2xl">
                <div class="relative z-10">
                    <h2 class="text-sm font-medium text-slate-400 uppercase tracking-wider mb-3">Available Database Balance</h2>
                    <div class="flex items-baseline space-x-2">
                        <span class="text-5xl font-bold balance-value"><bank:formatINR value="${liveAccount.balance}"/></span>
                    </div>
                    <p class="text-[10px] text-slate-600 mt-5 font-mono select-all">SYSTEM_NODE ID: ${liveAccount.accountId}</p>
                </div>
            </div>

            <!-- KYC Card -->
            <div class="kyc-card glass-card rounded-2xl p-6 flex flex-col justify-center items-center text-center shadow-lg">
                <h2 class="text-sm font-medium text-slate-400 uppercase tracking-wider mb-4">KYC Node Protocol</h2>
                
                <c:choose>
                    <c:when test="${sessionScope.account.kycStatus == 'APPROVED'}">
                        <div class="kyc-icon-ring h-16 w-16 rounded-full bg-emerald-500/15 flex items-center justify-center mb-3">
                            <svg class="w-8 h-8 text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                        </div>
                        <span class="text-emerald-400 font-semibold tracking-widest text-sm">AUTHORIZED</span>
                        <p class="text-xs text-slate-500 mt-2">Full outbound transfer infrastructure verified.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="h-16 w-16 rounded-full bg-amber-500/15 flex items-center justify-center mb-3" style="animation: kycPulse 2.5s ease-in-out infinite; --tw-shadow: 0 0 0 0 rgba(245,158,11,0.3);">
                            <svg class="w-8 h-8 text-amber-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg>
                        </div>
                        <span class="text-amber-400 font-semibold tracking-widest text-sm">RESTRICTED</span>
                        <p class="text-xs text-slate-500 mt-2">Database transfers blocked.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Transfer + Log Row -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 anim-entrance-d1">
            
            <!-- Transfer Panel -->
            <div class="transfer-card glass-card rounded-2xl p-6 lg:col-span-1 border border-slate-800 shadow-xl self-start">
                <h3 class="text-lg font-semibold text-white mb-6 border-b border-slate-800 pb-4 flex items-center">
                    <svg class="w-5 h-5 mr-2 text-indigo-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4"/></svg>
                    Digital Transfer Tunnel
                </h3>
                
                <form action="TransferServlet" method="POST" class="space-y-5">
                    <div>
                        <label class="block text-xs font-medium text-slate-400 mb-1.5 uppercase tracking-wider">Recipient Account Number</label>
                        <input type="number" name="to_account" required class="input-glow w-full px-4 py-3 bg-slate-900/80 border border-slate-700 rounded-xl focus:outline-none text-sm text-white font-mono placeholder-slate-600" placeholder="e.g. 1002">
                    </div>
                    <div>
                        <label class="block text-xs font-medium text-slate-400 mb-1.5 uppercase tracking-wider">Exact Value (₹)</label>
                        <input type="number" step="0.01" name="amount" required class="input-glow w-full px-4 py-3 bg-slate-900/80 border border-slate-700 rounded-xl focus:outline-none text-sm text-white font-mono placeholder-slate-600" placeholder="0.00">
                    </div>
                    <div>
                        <label class="block text-xs font-medium text-slate-400 mb-1.5 uppercase tracking-wider">Infrastructure Setup</label>
                        <div class="grid grid-cols-2 gap-3">
                            <label class="radio-txn flex items-center justify-center px-4 py-2.5 border border-slate-700 rounded-xl cursor-pointer">
                                <input type="radio" name="transaction_type" value="IMPS" checked class="hidden peer">
                                <span class="text-xs font-bold text-slate-400 tracking-wider">IMPS</span>
                            </label>
                            <label class="radio-txn flex items-center justify-center px-4 py-2.5 border border-slate-700 rounded-xl cursor-pointer">
                                <input type="radio" name="transaction_type" value="NEFT" class="hidden peer">
                                <span class="text-xs font-bold text-slate-400 tracking-wider">NEFT</span>
                            </label>
                        </div>
                    </div>
                    
                    <c:choose>
                        <c:when test="${sessionScope.account.kycStatus == 'APPROVED'}">
                            <button type="submit" class="btn-transfer w-full mt-4 py-3.5 bg-gradient-to-r from-indigo-600 to-blue-600 text-white text-sm font-semibold tracking-wider uppercase rounded-xl shadow-xl cursor-pointer focus:outline-none">
                                Authorize Ledger Event
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button type="button" disabled class="w-full mt-4 py-3.5 bg-slate-700 text-slate-500 text-sm font-semibold tracking-wider uppercase rounded-xl opacity-50 cursor-not-allowed">
                                Authorize Ledger Event
                            </button>
                            <p class="text-[10px] text-amber-500 text-center mt-3 uppercase tracking-widest font-semibold">Security Level: INSUFFICIENT</p>
                        </c:otherwise>
                    </c:choose>
                </form>
            </div>

            <!-- Transaction Log -->
            <div class="txn-log-card glass-card rounded-2xl p-0 lg:col-span-2 border border-slate-800 overflow-hidden flex flex-col shadow-xl">
                <div class="p-6 border-b border-slate-800 flex justify-between items-center bg-slate-800/20">
                    <h3 class="text-lg font-semibold text-white flex items-center">
                        <svg class="w-5 h-5 mr-2 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>
                        Transaction Event Log
                    </h3>
                </div>
                
                <div class="overflow-x-auto flex-1 p-2">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr>
                                <th class="py-3 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Date</th>
                                <th class="py-3 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Reference</th>
                                <th class="py-3 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Method</th>
                                <th class="py-3 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Status</th>
                                <th class="py-3 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider text-right">Value</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-800/50">
                            
                            <c:forEach var="txn" items="${txnDao.getRecentTransactions(sessionScope.account.accountId)}">
                            <tr class="txn-row">
                                <td class="py-4 px-4 text-sm text-slate-300">
                                    <fmt:formatDate value="${txn.createdAt}" pattern="dd MMM yyyy, HH:mm" />
                                </td>
                                <td class="py-4 px-4 text-sm font-mono text-slate-400">TXN-${txn.transactionId}</td>
                                
                                <td class="py-4 px-4 text-sm">
                                    <c:choose>
                                        <c:when test="${txn.transactionType == 'IMPS'}"><span class="px-2.5 py-1 bg-blue-900/30 border border-blue-500/20 text-blue-400 text-[10px] uppercase font-bold tracking-widest rounded-md">IMPS</span></c:when>
                                        <c:when test="${txn.transactionType == 'NEFT'}"><span class="px-2.5 py-1 bg-purple-900/30 border border-purple-500/20 text-purple-400 text-[10px] uppercase font-bold tracking-widest rounded-md">NEFT</span></c:when>
                                    </c:choose>
                                </td>
                                
                                <td class="py-4 px-4 text-sm">
                                    <c:choose>
                                        <c:when test="${txn.status == 'COMPLETED'}">
                                            <span class="flex items-center text-emerald-400 text-[11px] font-bold tracking-wider"><span class="w-1.5 h-1.5 bg-emerald-400 rounded-full mr-2 shadow-[0_0_8px_rgba(52,211,153,0.8)]"></span>CLEARED</span>
                                        </c:when>
                                        <c:when test="${txn.status == 'PENDING'}">
                                            <span class="flex items-center text-amber-400 text-[11px] font-bold tracking-wider"><span class="w-1.5 h-1.5 bg-amber-400 rounded-full mr-2 shadow-[0_0_8px_rgba(251,191,36,0.8)]"></span>QUEUEING</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="flex items-center text-red-500 text-[11px] font-bold tracking-wider"><span class="w-1.5 h-1.5 bg-red-500 rounded-full mr-2 shadow-[0_0_8px_rgba(239,68,68,0.8)]"></span>CORRUPT</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="py-4 px-4 text-sm text-right">
                                    <c:choose>
                                        <c:when test="${txn.fromAccount == sessionScope.account.accountId}">
                                            <span class="text-red-400 font-semibold">- <bank:formatINR value="${txn.amount}"/></span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-emerald-400 font-semibold">+ <bank:formatINR value="${txn.amount}"/></span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            </c:forEach>
                            
                            <c:if test="${empty txnDao.getRecentTransactions(sessionScope.account.accountId)}">
                                <tr><td colspan="5" class="py-16 text-center text-slate-500/80 font-medium text-sm">
                                    <svg class="w-10 h-10 mx-auto mb-3 text-slate-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>
                                    No transfers documented yet.
                                </td></tr>
                            </c:if>

                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        </div>

        <!-- Service Kiosk Row -->
        <jsp:useBean id="serviceDao" class="com.bankmanage.dao.ServiceRequestDAO" scope="request" />
        <h3 class="text-xl font-bold text-white mt-12 mb-6 flex items-center anim-entrance-d2 border-b border-slate-800 pb-2">
            <svg class="w-6 h-6 mr-2 text-indigo-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/></svg>
            Branch Services Kiosk
        </h3>
        
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 anim-entrance-d2 mb-10">
            <!-- Deposit Action -->
            <div class="transfer-card glass-card rounded-2xl p-6 border border-slate-800 shadow-lg flex flex-col justify-between">
                <div>
                    <div class="h-12 w-12 rounded-xl bg-emerald-500/10 flex items-center justify-center mb-4">
                        <svg class="w-6 h-6 text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/></svg>
                    </div>
                    <h4 class="text-md font-semibold text-white mb-2">Cash Deposit Request</h4>
                    <p class="text-xs text-slate-500 mb-5">Initiate a physical cash branch deposit. Funds will reflect in your account upon Admin approval.</p>
                </div>
                <form action="CustomerActionServlet" method="POST">
                    <input type="hidden" name="request_type" value="DEPOSIT">
                    <div class="flex items-center space-x-3 mt-auto">
                        <input type="number" step="0.01" name="amount" required class="input-glow flex-1 px-4 py-3 bg-slate-900/80 border border-slate-700 rounded-xl focus:outline-none text-sm text-white font-mono placeholder-slate-600" placeholder="0.00 ₹">
                        <button type="submit" class="btn-transfer px-5 py-3 bg-slate-800 text-white text-sm font-semibold tracking-wider rounded-xl shadow-xl cursor-pointer focus:outline-none border border-slate-600 hover:border-emerald-500 hover:text-emerald-400 transition-colors">
                            Submit
                        </button>
                    </div>
                </form>
            </div>

            <!-- Debit Card Action -->
            <div class="transfer-card glass-card rounded-2xl p-6 border border-slate-800 shadow-lg flex flex-col justify-between relative overflow-hidden group">
                <div class="absolute -right-6 -top-6 w-32 h-32 bg-blue-500/5 rounded-full blur-2xl group-hover:bg-blue-500/10 transition-colors"></div>
                <div>
                    <div class="h-12 w-12 rounded-xl bg-blue-500/10 flex items-center justify-center mb-4">
                        <svg class="w-6 h-6 text-blue-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/></svg>
                    </div>
                    <h4 class="text-md font-semibold text-white mb-2">Request Debit Card</h4>
                    <p class="text-xs text-slate-500 mb-5">Apply for a premium contactless debit card linked directly to your current balance.</p>
                </div>
                <form action="CustomerActionServlet" method="POST">
                    <input type="hidden" name="request_type" value="DEBIT_CARD">
                    <button type="submit" class="btn-transfer w-full mt-auto py-3 bg-slate-800 text-white text-sm font-semibold tracking-wider uppercase rounded-xl shadow-xl cursor-pointer focus:outline-none border border-slate-600 hover:border-blue-500 hover:text-blue-400 transition-colors">
                        Apply Now
                    </button>
                </form>
            </div>

            <!-- Credit Card Action -->
            <div class="transfer-card glass-card rounded-2xl p-6 border border-slate-800 shadow-lg flex flex-col justify-between relative overflow-hidden group">
                <div class="absolute -right-6 -top-6 w-32 h-32 bg-purple-500/5 rounded-full blur-2xl group-hover:bg-purple-500/10 transition-colors"></div>
                <div>
                    <div class="h-12 w-12 rounded-xl bg-purple-500/10 flex items-center justify-center mb-4">
                        <svg class="w-6 h-6 text-purple-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    </div>
                    <h4 class="text-md font-semibold text-white mb-2">Apply for Credit Card</h4>
                    <p class="text-xs text-slate-500 mb-5">Unlock exclusive rewards, airport lounge access, and a ₹5,00,000 credit limit dynamically assigned.</p>
                </div>
                <form action="CustomerActionServlet" method="POST">
                    <input type="hidden" name="request_type" value="CREDIT_CARD">
                    <button type="submit" class="btn-transfer w-full mt-auto py-3 bg-slate-800 text-white text-sm font-semibold tracking-wider uppercase rounded-xl shadow-xl cursor-pointer focus:outline-none border border-slate-600 hover:border-purple-500 hover:text-purple-400 transition-colors">
                        Apply Now
                    </button>
                </form>
            </div>
        </div>

        <!-- Service Request Log -->
        <div class="txn-log-card glass-card rounded-2xl p-0 border border-slate-800 overflow-hidden flex flex-col shadow-xl anim-entrance-d2 mb-8">
            <div class="p-6 border-b border-slate-800 flex justify-between items-center bg-slate-800/20">
                <h3 class="text-sm font-bold text-slate-400 uppercase tracking-widest flex items-center">
                    <svg class="w-4 h-4 mr-2 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
                    Service Application History
                </h3>
            </div>
            
            <div class="overflow-x-auto flex-1 p-2">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr>
                            <th class="py-3 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Date Submitted</th>
                            <th class="py-3 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Ref ID</th>
                            <th class="py-3 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Service Type</th>
                            <th class="py-3 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Value</th>
                            <th class="py-3 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Status</th>
                            <th class="py-3 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Resolution Date</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-800/50">
                        <c:forEach var="req" items="${serviceDao.getUserRequests(sessionScope.account.accountId)}">
                        <tr class="txn-row">
                            <td class="py-4 px-4 text-sm text-slate-300">
                                <fmt:formatDate value="${req.createdAt}" pattern="dd MMM, HH:mm" />
                            </td>
                            <td class="py-4 px-4 text-sm font-mono text-slate-500">SRV-${req.requestId}</td>
                            <td class="py-4 px-4 text-sm text-slate-200 font-medium">${req.requestType}</td>
                            <td class="py-4 px-4 text-sm text-slate-400">
                                <c:if test="${not empty req.amount and req.amount > 0}">
                                    <bank:formatINR value="${req.amount}"/>
                                </c:if>
                                <c:if test="${empty req.amount or req.amount == 0}">
                                    -
                                </c:if>
                            </td>
                            <td class="py-4 px-4 text-sm">
                                <c:choose>
                                    <c:when test="${req.status == 'APPROVED'}">
                                        <span class="px-2.5 py-1 bg-emerald-900/30 border border-emerald-500/20 text-emerald-400 text-[10px] uppercase font-bold tracking-widest rounded-md">APPROVED</span>
                                    </c:when>
                                    <c:when test="${req.status == 'REJECTED'}">
                                        <span class="px-2.5 py-1 bg-red-900/30 border border-red-500/20 text-red-400 text-[10px] uppercase font-bold tracking-widest rounded-md">REJECTED</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="px-2.5 py-1 bg-blue-900/30 border border-blue-500/20 text-blue-400 text-[10px] uppercase font-bold tracking-widest rounded-md">PENDING</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="py-4 px-4 text-sm text-slate-500 font-mono text-xs">
                                <c:if test="${not empty req.resolvedAt}">
                                    <fmt:formatDate value="${req.resolvedAt}" pattern="dd MMM, HH:mm" />
                                </c:if>
                                <c:if test="${empty req.resolvedAt}">
                                    Awating Review
                                </c:if>
                            </td>
                        </tr>
                        </c:forEach>
                        <c:if test="${empty serviceDao.getUserRequests(sessionScope.account.accountId)}">
                            <tr><td colspan="6" class="py-8 text-center text-slate-600 font-medium text-xs uppercase tracking-widest">
                                No service requests found.
                            </td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

    </main>

</body>
</html>
