<?php

// Copyright (c) ppy Pty Ltd <contact@ppy.sh>. Licensed under the GNU Affero General Public License v3.0.
// See the LICENCE file in the repository root for full licence text.

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('user_profile_customizations', function (Blueprint $table) {
            $table->dropColumn('cover_json');
        });
    }

    public function down(): void
    {
        Schema::table('user_profile_customizations', function (Blueprint $table) {
            $table->text('cover_json')->after('user_id')->nullable(true);
        });
    }
};
