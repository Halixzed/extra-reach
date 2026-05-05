@extends('layouts.app')

@section('content')
    <h1 class="text-3xl font-bold mb-2">Projects</h1>
    <p class="text-gray-400 mb-10">A collection of things I've built.</p>

    @if($projects->isEmpty())
        <p class="text-gray-500">No projects yet.</p>
    @else
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            @foreach($projects as $project)
                <div class="bg-gray-900 border border-gray-800 rounded-xl p-6">
                    <h2 class="text-xl font-semibold mb-2">{{ $project->title }}</h2>
                    <p class="text-gray-400 text-sm mb-4">{{ $project->description }}</p>

                    @if($project->tech_stack)
                        <div class="flex flex-wrap gap-2 mb-4">
                            @foreach($project->tech_stack as $tech)
                                <span class="text-xs bg-gray-800 text-gray-300 px-2 py-1 rounded">{{ $tech }}</span>
                            @endforeach
                        </div>
                    @endif

                    @if($project->url)
                        <a href="{{ $project->url }}" target="_blank" class="text-sm text-blue-400 hover:underline">View project →</a>
                    @endif
                </div>
            @endforeach
        </div>
    @endif
@endsection
