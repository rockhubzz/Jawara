<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Symfony\Component\Process\Process;

class StartServices extends Command
{
    protected $signature = 'app:start';
    protected $description = 'Start Laravel API server and Discover Listener together';

    public function handle()
    {
        $this->info("Starting Laravel API server and discovery listener...");

        // Start Laravel API server
        // Detect LAN IP
        $lanIp = getHostByName(getHostName());

        // Fallback if getHostByName returns localhost
        if ($lanIp === "127.0.0.1") {
            $lanIp = trim(shell_exec("hostname -I | awk '{print $1}'")) ?: "0.0.0.0";
        }

        $this->info("→ Detected LAN IP: $lanIp");

        // Start API server bound to LAN IP
        $serve = new Process([
            'php', 'artisan', 'serve',
            "--host={$lanIp}",
            '--port=8000'
        ]);

        $serve->setTimeout(0); // run forever
        $serve->start();

        $this->info("→ API server running on http://{$lanIp}:8000");

        // Start the Discovery Listener
        $listener = new Process(['php', 'artisan', 'discover:listen']);
        $listener->setTimeout(0);
        $listener->start();

        $this->info("→ Discovery listener started on port 8888");

        $this->info("\nBoth services are now running. Press Ctrl+C to stop.\n");

        // Keep the command alive so child processes continue running
        while (true) {
            usleep(500000); // 0.5 sec
        }

        return Command::SUCCESS;
    }
}
