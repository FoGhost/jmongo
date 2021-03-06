# Copyright (C) 2008-2010 10gen Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module Mongo

  class DB
    include Mongo::JavaImpl::Db_
    include Mongo::JavaImpl::Utils

    attr_reader :j_db
    attr_reader :name
    attr_reader :connection

    def initialize(db_name, connection, options={})
      @name       = db_name
      @connection = connection
      @j_db = @connection.connection.get_db db_name
    end

    def authenticate(username, password, save_auth=true)
      raise_not_implemented
    end

    def add_user(username, password)
      raise_not_implemented
    end

    def remove_user(username)
      raise_not_implemented
    end

    def logout
      raise_not_implemented
    end

    def collection_names
      names = collections_info.to_a.collect { |doc| doc['name'] || '' }
      names = names.delete_if {|name| name.index(@name).nil? || name.index('$')}
      names.map {|name| name.sub(@name + '.', '')}
    end

    def collections
      collection_names.map do |name|
        Collection.new(self, name)
      end
    end

    def collections_info(coll_name=nil)
      selector = {}
      selector[:name] = full_collection_name(coll_name) if coll_name
      Cursor.new(Collection.new(self, SYSTEM_NAMESPACE_COLLECTION), :selector => selector)
    end

    def create_collection(name, options={})
      @j_db.createCollection(name, to_dbobject(options))
    end

    def collection(name)
      Collection.new self, name
    end
    alias_method :[], :collection

    def drop_collection(name)
      coll = collection(name).j_collection.drop
    end

    def error
      raise_not_implemented
    end

    def last_status
      from_dbobject(@j_db.getLastError)
    end

    def error?
      raise_not_implemented
    end

    def previous_error
      raise_not_implemented
    end

    def reset_error_history
      raise_not_implemented
    end

    def query(collection, query, admin=false)
      raise_not_implemented
    end

    def dereference(dbref)
      raise_not_implemented
    end

    def eval(code, *args)
      raise_not_implemented
    end

    def rename_collection(from, to)
      raise_not_implemented
    end

    def drop_index(collection_name, index_name)
      raise_not_implemented
    end

    def index_information(collection_name)
      raise_not_implemented
    end

    def stats
      exec_command(:dbstats)
    end

    def create_index(collection_name, field_or_spec, unique=false)
      collection(collection_name).create_indexes(field_or_spec,{:unique=>unique})
    end

    def ok?(doc)
      doc['ok'] == 1.0
    end

    def command(selector, opts={})
      raise_not_implemented
    end

    def full_collection_name(collection_name)
      "#{@name}.#{collection_name}"
    end

    def pk_factory
      raise_not_implemented
    end

    def pk_factory=(pk_factory)
      raise_not_implemented
    end

    def profiling_level
      raise_not_implemented
    end

    def profiling_level=(level)
      raise_not_implemented
    end

    def profiling_info
      raise_not_implemented
    end

    def validate_collection(name)
      raise_not_implemented
    end
    # additions to the ruby driver
    def has_collection?(name)
      has_coll name
    end
  end # class DB

end # module Mongo
