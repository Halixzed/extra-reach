<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ config('app.name') }}</title>
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>
<body class="bg-gray-950 text-gray-100 min-h-screen">
    <nav class="border-b border-gray-800 px-6 py-4">
        <div class="max-w-5xl mx-auto flex items-center justify-between">
            <a href="/" class="text-lg font-semibold tracking-tight">Haris Ahmad</a>
        </div>
    </nav>

    <main class="max-w-5xl mx-auto px-6 py-12">
        @yield('content')
    </main>
</body>
</html>
