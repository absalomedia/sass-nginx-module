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

=== TEST 1: default output style
--- config
    location ~ ^.*\.scss$ {
        root  $TEST_NGINX_FIXTURE_DIR;

        sass_compile  on;

        body_filter_by_lua_block {
            ngx.arg[1] = string.sub(ngx.arg[1], 1, -2) .. "\n"
        }
    }
--- request
    GET /conf_output.scss
--- response_body
.output {
  background-color: white; }
  .output .with-style {
    color: black; }


=== TEST 1: output style "compact"
--- config
    location ~ ^.*\.scss$ {
        root  $TEST_NGINX_FIXTURE_DIR;

        sass_compile       on;
        sass_output        compact;

        body_filter_by_lua_block {
            ngx.arg[1] = string.sub(ngx.arg[1], 1, -2) .. "\n"
        }
    }
--- request
    GET /conf_output.scss
--- response_body
.output { background-color: white; }

.output .with-style { color: black; }


=== TEST 1: output style "compressed"
--- config
    location ~ ^.*\.scss$ {
        root  $TEST_NGINX_FIXTURE_DIR;

        sass_compile       on;
        sass_output  compressed;

        body_filter_by_lua_block {
            ngx.arg[1] = string.sub(ngx.arg[1], 1, -2) .. "\n"
        }
    }
--- request
    GET /conf_output.scss
--- response_body
.output{background-color:#fff}.output .with-style{color:#000}


=== TEST 1: output style "expanded"
--- config
    location ~ ^.*\.scss$ {
        root  $TEST_NGINX_FIXTURE_DIR;

        sass_compile       on;
        sass_output  expanded;

        body_filter_by_lua_block {
            ngx.arg[1] = string.sub(ngx.arg[1], 1, -2) .. "\n"
        }
    }
--- request
    GET /conf_output.scss
--- response_body
.output {
  background-color: white;
}

.output .with-style {
  color: black;
}


=== TEST 1: output style "nested"
--- config
    location ~ ^.*\.scss$ {
        root  $TEST_NGINX_FIXTURE_DIR;

        sass_compile       on;
        sass_output  nested;

        body_filter_by_lua_block {
            ngx.arg[1] = string.sub(ngx.arg[1], 1, -2) .. "\n"
        }
    }
--- request
    GET /conf_output.scss
--- response_body
.output {
  background-color: white; }
  .output .with-style {
    color: black; }
