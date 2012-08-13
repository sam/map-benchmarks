require "java"

hash_map = {}

java_import com.hazelcast.core.Hazelcast
at_exit { Hazelcast.shutdown_all }
hazel_map = Hazelcast.get_map "benchmark"

java_import org.infinispan.Cache
java_import org.infinispan.manager.DefaultCacheManager
infinispan_map = DefaultCacheManager.new.get_cache

require "benchmark"

COUNT = 10_000

def iterate_set(map)
  COUNT.times do |i|
    map[i.to_s] = i
  end
end

def iterate_get(map)
  COUNT.times do |i|
    map[i.to_s].to_s
  end
end

Benchmark::bmbm do |x|
  x.report("Hash:set") do
    iterate_set hash_map
  end

  x.report("Hazelcast:set") do
    iterate_set hazel_map
  end

  x.report("Infinispan:set") do
    iterate_set infinispan_map
  end

  x.report("Hash:get") do
    iterate_get hash_map
  end

  x.report("Hazelcast:get") do
    iterate_get hazel_map
  end

  x.report("Infinispan:get") do
    iterate_get infinispan_map
  end
end