require 'logger'
require 'test/unit'

require 'LL_parser'

require 'test_LL_parser'
require 'test_LL_regex_token'

$LOGGER = Logger.new(STDOUT)
$LOGGER.level = Logger::DEBUG
