<?php

namespace App\Domains\Alert\Repositories\Interfaces;

interface AlertRepositoryInterface
{
    public function create(array $data);
    public function getAllForUser(int $userId);
    public function delete(int $id, int $userId);
}
