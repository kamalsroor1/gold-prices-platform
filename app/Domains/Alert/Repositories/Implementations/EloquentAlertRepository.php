<?php

namespace App\Domains\Alert\Repositories\Implementations;

use App\Domains\Alert\Models\Alert;
use App\Domains\Alert\Repositories\Interfaces\AlertRepositoryInterface;

class EloquentAlertRepository implements AlertRepositoryInterface
{
    public function create(array $data)
    {
        return Alert::create($data);
    }

    public function getAllForUser(int $userId)
    {
        return Alert::where('user_id', $userId)->get();
    }

    public function delete(int $id, int $userId)
    {
        return Alert::where('id', $id)->where('user_id', $userId)->delete();
    }
}
