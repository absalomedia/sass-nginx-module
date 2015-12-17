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

=== TEST 1: default source type
--- config
    location ~ ^.*\.scss$ {
        root  $TEST_NGINX_FIXTURE_DIR;

        sass_compile  on;

        body_filter_by_lua_block {
            ngx.arg[1] = string.sub(ngx.arg[1], 1, -2) .. "\n"
        };
    }
--- request
    GET /conf_comments.scss
--- response_body
html {
  background-color: black; }

body {
  color: white; }


=== TEST 2: source type "off"
--- config
    location ~ ^.*\.scss$ {
        root  $TEST_NGINX_FIXTURE_DIR;

        sass_compile          on;
        sass_source_type      off;

        body_filter_by_lua_block {
            ngx.arg[1] = string.sub(ngx.arg[1], 1, -2) .. "\n"
        }
    }
--- request
    GET /conf_comments.scss
--- response_body
html {
  background-color: black; }

body {
  color: white; }


=== TEST 3: source type "on"
--- config
    location ~ ^.*\.sass$ {
        root  $TEST_NGINX_FIXTURE_DIR;

        sass_compile          on;
        sass_source_type      on;

        body_filter_by_lua_block {
            ngx.arg[1] = string.sub(ngx.arg[1], 1, -2) .. "\n"
        }
    }
--- request
    GET /conf_source-type.sass
--- response_body
body {
  background: red;
   border: 1px solid green; }

