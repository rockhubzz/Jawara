<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class DiscoveryListener extends Command
{
    protected $signature = 'discover:listen';
    protected $description = 'UDP LAN discovery listener';

    public function handle()
    {
        $this->info("Discovery listener started on UDP 8888…");

        $socket = socket_create(AF_INET, SOCK_DGRAM, SOL_UDP);
        socket_set_option($socket, SOL_SOCKET, SO_BROADCAST, 1);
            socket_bind($socket, '0.0.0.0', 8888);

        while (true) {
            $from = '';
            $port = 0;

            // Receive message
            socket_recvfrom($socket, $buffer, 1024, 0, $from, $port);

            if (trim($buffer) === "DISCOVER") {
                $this->info("Discovery request from $from");

                // Correct server IP
                $serverIp = gethostbyname(gethostname());

                // Build reply
                $reply = "SERVER:$serverIp";

                // Send with correct length
                socket_sendto($socket, $reply, strlen($reply), 0, $from, $port);
            }
        }
    }
}
