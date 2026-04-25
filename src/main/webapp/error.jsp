<%@ page language="java" isErrorPage="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Diagnostics - Bharat Global Bank</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body { background-color: #0f172a; font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; }
        .glitch-effect { text-shadow: 2px 2px 0px rgba(239, 68, 68, 0.4), -2px -2px 0px rgba(59, 130, 246, 0.4); }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center p-4 bg-slate-900 text-slate-200">
    <!-- Alert Background Nodes -->
    <div class="absolute top-1/4 left-1/4 w-96 h-96 bg-red-600 rounded-full mix-blend-multiply filter blur-3xl opacity-10"></div>
    <div class="absolute bottom-1/4 right-1/4 w-96 h-96 bg-amber-600 rounded-full mix-blend-multiply filter blur-3xl opacity-10"></div>

    <div class="max-w-2xl w-full bg-slate-800/60 backdrop-blur-xl border-t border-red-500/50 rounded-2xl shadow-2xl p-8 relative z-10 text-center">
        
        <div class="mx-auto w-20 h-20 bg-red-500/10 flex items-center justify-center rounded-full mb-6">
            <svg class="w-10 h-10 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg>
        </div>

        <h1 class="text-4xl font-bold text-white mb-2 glitch-effect">SYSTEM EXCEPTION</h1>
        <h2 class="text-xl text-slate-400 mb-8 font-mono uppercase tracking-widest text-sm">HTTP Error Intercepted</h2>

        <div class="bg-gray-900 p-4 rounded-lg border border-red-500/20 text-left mb-8 overflow-x-auto">
            <p class="text-red-400 text-xs font-mono mb-2 uppercase select-all">Stack Trace Diagnostic:</p>
            <p class="text-slate-300 font-mono text-sm leading-relaxed">
                <% 
                   if (exception != null) { 
                       out.print("CRITICAL: " + exception.getMessage()); 
                   } else { 
                       out.print("The application server encountered an unexpected routing error (404) or a dead resource link. The framework has automatically aborted the execution thread to protect database integrity."); 
                   } 
                %>
            </p>
        </div>

        <p class="text-slate-400 text-sm mb-8">Our enterprise engineering team has been notified of this infrastructure failure. Your financial data remains securely encrypted and unaffected.</p>

        <a href="login.jsp" class="inline-block px-8 py-3 bg-red-600 hover:bg-red-500 font-semibold text-white rounded shadow-lg transition transform hover:-translate-y-0.5">
            Return to Authorized Portal
        </a>
    </div>
</body>
</html>
