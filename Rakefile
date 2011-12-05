#!/usr/bin/env rake
require "bundler/gem_tasks"

module Bundler
  class GemHelper
    protected

    def rubygem_push(path)
      `scp #{path} lome.dreamhost.com:/var/www/gems.sugarpond.net/gems/`
      `ssh popper.sugarpond.net gem generate_index -d /var/www/gems.sugarpond.net/`
    end
  end
end
