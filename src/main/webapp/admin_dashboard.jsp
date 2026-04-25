<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="bank" uri="http://com.bankmanage.tags" %>
<%
    if (session.getAttribute("role") == null || !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<jsp:useBean id="appDao" class="com.bankmanage.dao.ApplicationDAO" scope="request" />
<jsp:useBean id="serviceDao" class="com.bankmanage.dao.ServiceRequestDAO" scope="request" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Area - Bharat Global Bank</title>
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

        /* ═══ Page Entrance ═══ */
        .anim-entrance { animation: entrance 0.7s cubic-bezier(0.16, 1, 0.3, 1) forwards; opacity: 0; }
        .anim-entrance-d1 { animation: entrance 0.7s cubic-bezier(0.16, 1, 0.3, 1) 0.15s forwards; opacity: 0; }
        .anim-entrance-d2 { animation: entrance 0.7s cubic-bezier(0.16, 1, 0.3, 1) 0.3s forwards; opacity: 0; }
        @keyframes entrance { 
            from { opacity: 0; transform: translateY(25px); } 
            to   { opacity: 1; transform: translateY(0); } 
        }

        /* ═══ Navbar Slide Down ═══ */
        .nav-slide { animation: navSlide 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        @keyframes navSlide { from { transform: translateY(-100%); } to { transform: translateY(0); } }

        /* ═══ Row Hover ═══ */
        .table-row {
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .table-row:hover {
            background: rgba(30, 41, 59, 0.6) !important;
            transform: scale(1.005);
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
        }

        /* ═══ Action Buttons ═══ */
        .btn-approve {
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .btn-approve:hover {
            transform: translateY(-2px) scale(1.03);
            box-shadow: 0 6px 20px rgba(16,185,129,0.3);
            background: rgba(16,185,129,0.25);
        }
        .btn-approve:active { transform: translateY(0) scale(0.97); }

        .btn-reject {
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .btn-reject:hover {
            transform: translateY(-2px) scale(1.03);
            box-shadow: 0 6px 20px rgba(239,68,68,0.3);
            background: rgba(239,68,68,0.25);
        }
        .btn-reject:active { transform: translateY(0) scale(0.97); }

        /* ═══ Logout Hover ═══ */
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

        /* ═══ Live Indicator ═══ */
        .live-dot {
            width: 8px; height: 8px;
            background: #f59e0b;
            border-radius: 50%;
            display: inline-block;
            margin-right: 6px;
            animation: livePulse 1.5s ease-in-out infinite;
            box-shadow: 0 0 8px rgba(245,158,11,0.5);
        }
        @keyframes livePulse { 0%, 100% { opacity: 1; transform: scale(1); } 50% { opacity: 0.5; transform: scale(0.8); } }

        /* ═══ Scrollbar ═══ */
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #334155; border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background: #475569; }
    </style>
</head>
<body class="min-h-screen text-slate-200 bg-slate-900">
    
    <nav class="glass-card sticky top-0 z-50 border-b border-slate-800 nav-slide">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex items-center justify-between h-16">
                <div class="flex items-center">
                    <span class="text-xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-red-400 to-orange-400">Bharat Global Bank // ADMIN PORTAL</span>
                </div>
                <div class="flex items-center space-x-4">
                    <span class="text-sm text-slate-400">Secure Access: <strong class="text-white">${sessionScope.account.fullName}</strong></span>
                    <form action="LogoutServlet" method="POST">
                        <button type="submit" class="logout-btn text-sm text-red-400 font-medium cursor-pointer">Logout Terminal</button>
                    </form>
                </div>
            </div>
        </div>
    </nav>

    <main class="max-w-[90rem] mx-auto px-4 sm:px-6 lg:px-8 py-8 mb-16">
        
        <!-- Account Registration Approvals -->
        <div class="mb-8 anim-entrance">
            <h2 class="text-2xl font-bold text-white flex items-center">
                <span class="live-dot"></span>
                Pending Account Applications
            </h2>
            <p class="text-slate-400 text-sm mt-1">Review residential & financial details before approving new applicants into the primary banking database.</p>
        </div>

        <div class="glass-card rounded-2xl border border-slate-800 overflow-hidden mt-6 shadow-2xl anim-entrance-d1 mb-12">
            <div class="overflow-x-auto p-2">
                <table class="w-full text-left border-collapse whitespace-nowrap">
                    <thead>
                        <tr class="border-b border-slate-800">
                            <th class="py-4 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">App ID</th>
                            <th class="py-4 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Full Name</th>
                            <th class="py-4 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Contact</th>
                            <th class="py-4 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Acct / Cur</th>
                            <th class="py-4 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Deposit</th>
                            <th class="py-4 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">KYC ID</th>
                            <th class="py-4 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider text-right">Action</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-800/50">
                        
                        <c:forEach var="app" items="${appDao.pendingApplications}">
                        <tr class="table-row text-sm">
                            <td class="py-5 px-4 font-mono text-slate-400">APP-${app.applicationId}</td>
                            <td class="py-5 px-4 font-medium text-white">${app.fullName}</td>
                            <td class="py-5 px-4 text-slate-400 text-xs">${app.email}<br>${app.phone}</td>
                            <td class="py-5 px-4 text-slate-300">${app.accountType} / ${app.currency}</td>
                            <td class="py-5 px-4 text-emerald-400 font-mono"><bank:formatINR value="${app.initialDeposit}"/></td>
                            <td class="py-5 px-4 text-slate-400 text-xs">${app.idType}<br><span class="font-mono text-white">${app.idNumber}</span></td>
                            <td class="py-5 px-4 text-right">
                                <form action="AdminApplicationServlet" method="POST" class="inline-flex space-x-2">
                                    <input type="hidden" name="application_id" value="${app.applicationId}">
                                    <button type="submit" name="action" value="APPROVE" class="btn-approve px-4 py-2 bg-emerald-600/15 text-emerald-400 rounded-lg border border-emerald-600/30 cursor-pointer text-xs font-semibold">Accept to DB</button>
                                    <button type="submit" name="action" value="REJECT" class="btn-reject px-4 py-2 bg-red-600/15 text-red-400 rounded-lg border border-red-600/30 cursor-pointer text-xs font-semibold">Reject</button>
                                </form>
                            </td>
                        </tr>
                        </c:forEach>
                        
                        <c:if test="${empty appDao.pendingApplications}">
                            <tr><td colspan="7" class="py-16 text-center text-slate-500 font-medium tracking-wide">
                                <svg class="w-12 h-12 mx-auto mb-4 text-slate-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                                All clear — no pending registrations right now.
                            </td></tr>
                        </c:if>

                    </tbody>
                </table>
            </div>
        </div>
        
        <!-- Service Requests Approval Hub -->
        <div class="mb-8 anim-entrance-d1 mt-12 bg-indigo-500/10 border border-indigo-500/20 px-6 py-4 rounded-xl flex items-center justify-between">
            <div>
                <h2 class="text-2xl font-bold text-indigo-400 flex items-center pt-1">
                    <svg class="w-6 h-6 mr-3 text-indigo-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/></svg>
                    Service Operations Queue
                </h2>
                <p class="text-indigo-300 text-sm mt-1">Approve pending branch deposits and card issuance protocols.</p>
            </div>
        </div>

        <div class="glass-card rounded-2xl border border-slate-800 overflow-hidden shadow-2xl anim-entrance-d2">
            <div class="overflow-x-auto p-2">
                <table class="w-full text-left border-collapse whitespace-nowrap">
                    <thead>
                        <tr class="border-b border-slate-800">
                            <th class="py-4 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Service ID</th>
                            <th class="py-4 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Timestamp</th>
                            <th class="py-4 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Account ID</th>
                            <th class="py-4 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Operation Type</th>
                            <th class="py-4 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider">Value</th>
                            <th class="py-4 px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider text-right">Action Target</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-800/50">
                        
                        <c:forEach var="req" items="${serviceDao.pendingRequests}">
                        <tr class="table-row text-sm">
                            <td class="py-5 px-4 font-mono text-slate-400">SRV-${req.requestId}</td>
                            <td class="py-5 px-4 text-slate-400 text-xs"><fmt:formatDate value="${req.createdAt}" pattern="dd MMM, HH:mm" /></td>
                            <td class="py-5 px-4 text-slate-300 font-mono">ACCT-${req.accountId}</td>
                            <td class="py-5 px-4 font-semibold text-indigo-300">${req.requestType}</td>
                            <td class="py-5 px-4 text-emerald-400 font-mono">
                                <c:if test="${not empty req.amount and req.amount > 0}">
                                    <bank:formatINR value="${req.amount}"/>
                                </c:if>
                                <c:if test="${empty req.amount or req.amount == 0}">
                                    -
                                </c:if>
                            </td>
                            <td class="py-5 px-4 text-right">
                                <form action="AdminActionServlet" method="POST" class="inline-flex space-x-2">
                                    <input type="hidden" name="request_id" value="${req.requestId}">
                                    <button type="submit" name="action" value="APPROVE" class="btn-approve px-4 py-2 bg-indigo-600/20 text-indigo-300 rounded-lg border border-indigo-500/30 cursor-pointer text-xs font-bold uppercase tracking-wider hover:bg-indigo-600 hover:text-white transition-all">Execute</button>
                                    <button type="submit" name="action" value="REJECT" class="btn-reject px-4 py-2 bg-red-600/15 text-red-400 rounded-lg border border-red-600/30 cursor-pointer text-xs font-bold uppercase tracking-wider">Deny</button>
                                </form>
                            </td>
                        </tr>
                        </c:forEach>
                        
                        <c:if test="${empty serviceDao.pendingRequests}">
                            <tr><td colspan="6" class="py-16 text-center text-slate-500 font-medium tracking-wide">
                                <svg class="w-12 h-12 mx-auto mb-4 text-slate-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
                                All service operations completed successfully.
                            </td></tr>
                        </c:if>

                    </tbody>
                </table>
            </div>
        </div>
        
    </main>

</body>
</html>
