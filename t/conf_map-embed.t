use File::Spec;
use Test::Nginx::Socket;

# setup testing environment
my $HtmlDir    = html_dir();
my $FixtureDir = File::Spec->catfile($HtmlDir, '..', '..', 'fixtures');

$ENV{TEST_NGINX_FIXTURE_DIR} = $FixtureDir;

# proceed with testing
repeat_each(2);
plan tests => repeat_each() * blocks() * 2;

no_root_location();
run_tests();

__DATA__

=== TEST 1: default source map embed
--- config
    location /default.scss {
        root  $TEST_NGINX_FIXTURE_DIR;

        sass_compile  on;

        body_filter_by_lua_block {
            ngx.arg[1] = string.sub(ngx.arg[1], 1, -2) .. "\n"
        }
    }
--- request
    GET /default.scss
--- response_body
body {
  background-color: white;
  color: black; }


=== TEST 2: source map embed "on"
--- config
    location /default.scss {
        root  $TEST_NGINX_FIXTURE_DIR;

        sass_compile           on;
        sass_map_embed         on;

         body_filter_by_lua_block {
            ngx.arg[1] = string.sub(ngx.arg[1], 1, -2) .. "\n"
        }
    }
--- request
    GET /default.scss
--- response_body_like: sourceMappingURL=data:application/json;base64
