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

        body_filter_by_lua 'ngx.arg[1] = string.sub(ngx.arg[1], 1, -2) .. "\\n"';
    }
--- request
    GET /conf_comments.scss
--- response_body
html {
  background-color: black; }

body {
  color: white; }


=== TEST 2: comments "off"
--- config
    location ~ ^.*\.scss$ {
        root  $TEST_NGINX_FIXTURE_DIR;

        sass_compile          on;
        sass_source_type      off;

        body_filter_by_lua 'ngx.arg[1] = string.sub(ngx.arg[1], 1, -2) .. "\\n"';
    }
--- request
    GET /conf_comments.scss
--- response_body
html {
  background-color: black; }

body {
  color: white; }


=== TEST 3: comments "on"
--- config
    location ~ ^.*\.scss$ {
        root  $TEST_NGINX_FIXTURE_DIR;

        sass_compile          on;
        sass_source_type      on;
    }
--- request
    GET /conf_source-type.sass
--- response_body
@mixin texto($font, $size, $color)
    font-family: $font
    font-size: $size
    color: $color
    margin: 0

@mixin shadow($x, $y, $blur, $color)
    text-shadow: $x $y $blur $color
    filter: Shadow(Color=$color, Direction=130, Strength=1)

@mixin filterS($x, $y, $blur, $color)
    -moz-box-shadow: $x $y $blur $color
    -webkit-box-shadow: $x $y $blur $color
    box-shadow: $x $y $blur $color

@mixin img($url, $w, $h)
    background:  url($url) 0 0 no-repeat
    width: $w
    height: $h
