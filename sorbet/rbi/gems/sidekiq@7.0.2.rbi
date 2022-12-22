# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `sidekiq` gem.
# Please instead update this file by running `bin/tapioca gem sidekiq`.

# Use `Sidekiq.transactional_push!` in your sidekiq.rb initializer
#
# source://sidekiq//lib/sidekiq/version.rb#3
module Sidekiq
  class << self
    # @yield [default_configuration]
    #
    # source://sidekiq//lib/sidekiq.rb#134
    def configure_client; end

    # Creates a Sidekiq::Config instance that is more tuned for embedding
    # within an arbitrary Ruby process. Notably it reduces concurrency by
    # default so there is less contention for CPU time with other threads.
    #
    #   inst = Sidekiq.configure_embed do |config|
    #     config.queues = %w[critical default low]
    #   end
    #   inst.run
    #   sleep 10
    #   inst.terminate
    #
    # NB: it is really easy to overload a Ruby process with threads due to the GIL.
    # I do not recommend setting concurrency higher than 2-3.
    #
    # NB: Sidekiq only supports one instance in memory. You will get undefined behavior
    # if you try to embed Sidekiq twice in the same process.
    #
    # @yield [cfg]
    #
    # source://sidekiq//lib/sidekiq.rb#122
    def configure_embed(&block); end

    # @yield [default_configuration]
    #
    # source://sidekiq//lib/sidekiq.rb#96
    def configure_server(&block); end

    # source://sidekiq//lib/sidekiq.rb#88
    def default_configuration; end

    # source://sidekiq//lib/sidekiq.rb#84
    def default_job_options; end

    # source://sidekiq//lib/sidekiq.rb#80
    def default_job_options=(hash); end

    # source://sidekiq//lib/sidekiq.rb#56
    def dump_json(object); end

    # @return [Boolean]
    #
    # source://sidekiq//lib/sidekiq.rb#64
    def ent?; end

    # source://sidekiq//lib/sidekiq.rb#101
    def freeze!; end

    # source://sidekiq//lib/sidekiq.rb#52
    def load_json(string); end

    # source://sidekiq//lib/sidekiq.rb#92
    def logger; end

    # @return [Boolean]
    #
    # source://sidekiq//lib/sidekiq.rb#60
    def pro?; end

    # source://sidekiq//lib/sidekiq.rb#72
    def redis(&block); end

    # source://sidekiq//lib/sidekiq.rb#68
    def redis_pool; end

    # @return [Boolean]
    #
    # source://sidekiq//lib/sidekiq.rb#48
    def server?; end

    # source://sidekiq//lib/sidekiq.rb#76
    def strict_args!(mode = T.unsafe(nil)); end

    # source://sidekiq//lib/sidekiq/transaction_aware_client.rb#33
    def transactional_push!; end

    # source://sidekiq//lib/sidekiq.rb#44
    def ❨╯°□°❩╯︵┻━┻; end
  end
end

# source://sidekiq//lib/sidekiq/client.rb#8
class Sidekiq::Client
  include ::Sidekiq::JobUtil

  # Sidekiq::Client is responsible for pushing job payloads to Redis.
  # Requires the :pool or :config keyword argument.
  #
  #   Sidekiq::Client.new(pool: Sidekiq::RedisConnection.create)
  #
  # Inside the Sidekiq process, you can reuse the configured resources:
  #
  #   Sidekiq::Client.new(config: config)
  #
  # @param pool [ConnectionPool] explicit Redis pool to use
  # @param config [Sidekiq::Config] use the pool and middleware from the given Sidekiq container
  # @param chain [Sidekiq::Middleware::Chain] use the given middleware chain
  # @return [Client] a new instance of Client
  #
  # source://sidekiq//lib/sidekiq/client.rb#45
  def initialize(*args, **kwargs); end

  # Define client-side middleware:
  #
  #   client = Sidekiq::Client.new
  #   client.middleware do |chain|
  #     chain.use MyClientMiddleware
  #   end
  #   client.push('class' => 'SomeJob', 'args' => [1,2,3])
  #
  # All client instances default to the globally-defined
  # Sidekiq.client_middleware but you can change as necessary.
  #
  # source://sidekiq//lib/sidekiq/client.rb#23
  def middleware(&block); end

  # The main method used to push a job to Redis.  Accepts a number of options:
  #
  #   queue - the named queue to use, default 'default'
  #   class - the job class to call, required
  #   args - an array of simple arguments to the perform method, must be JSON-serializable
  #   at - timestamp to schedule the job (optional), must be Numeric (e.g. Time.now.to_f)
  #   retry - whether to retry this job if it fails, default true or an integer number of retries
  #   backtrace - whether to save any error backtrace, default false
  #
  # If class is set to the class name, the jobs' options will be based on Sidekiq's default
  # job options. Otherwise, they will be based on the job class's options.
  #
  # Any options valid for a job class's sidekiq_options are also available here.
  #
  # All options must be strings, not symbols.  NB: because we are serializing to JSON, all
  # symbols in 'args' will be converted to strings.  Note that +backtrace: true+ can take quite a bit of
  # space in Redis; a large volume of failing jobs can start Redis swapping if you aren't careful.
  #
  # Returns a unique Job ID.  If middleware stops the job, nil will be returned instead.
  #
  # Example:
  #   push('queue' => 'my_queue', 'class' => MyJob, 'args' => ['foo', 1, :bat => 'bar'])
  #
  # source://sidekiq//lib/sidekiq/client.rb#85
  def push(item); end

  # Push a large number of jobs to Redis. This method cuts out the redis
  # network round trip latency.  I wouldn't recommend pushing more than
  # 1000 per call but YMMV based on network quality, size of job args, etc.
  # A large number of jobs can cause a bit of Redis command processing latency.
  #
  # Takes the same arguments as #push except that args is expected to be
  # an Array of Arrays.  All other keys are duplicated for each job.  Each job
  # is run through the client middleware pipeline and each job gets its own Job ID
  # as normal.
  #
  # Returns an array of the of pushed jobs' jids.  The number of jobs pushed can be less
  # than the number given if the middleware stopped processing for one or more jobs.
  #
  # @raise [ArgumentError]
  #
  # source://sidekiq//lib/sidekiq/client.rb#110
  def push_bulk(items); end

  # Returns the value of attribute redis_pool.
  #
  # source://sidekiq//lib/sidekiq/client.rb#31
  def redis_pool; end

  # Sets the attribute redis_pool
  #
  # @param value the value to set the attribute redis_pool to.
  #
  # source://sidekiq//lib/sidekiq/client.rb#31
  def redis_pool=(_arg0); end

  private

  # source://sidekiq//lib/sidekiq/client.rb#234
  def atomic_push(conn, payloads); end

  # source://sidekiq//lib/sidekiq/client.rb#210
  def raw_push(payloads); end

  class << self
    # Resque compatibility helpers.  Note all helpers
    # should go through Sidekiq::Job#client_push.
    #
    # Example usage:
    #   Sidekiq::Client.enqueue(MyJob, 'foo', 1, :bat => 'bar')
    #
    # Messages are enqueued to the 'default' queue.
    #
    # source://sidekiq//lib/sidekiq/client.rb#175
    def enqueue(klass, *args); end

    # Example usage:
    #   Sidekiq::Client.enqueue_in(3.minutes, MyJob, 'foo', 1, :bat => 'bar')
    #
    # source://sidekiq//lib/sidekiq/client.rb#203
    def enqueue_in(interval, klass, *args); end

    # Example usage:
    #   Sidekiq::Client.enqueue_to(:queue_name, MyJob, 'foo', 1, :bat => 'bar')
    #
    # source://sidekiq//lib/sidekiq/client.rb#182
    def enqueue_to(queue, klass, *args); end

    # Example usage:
    #   Sidekiq::Client.enqueue_to_in(:queue_name, 3.minutes, MyJob, 'foo', 1, :bat => 'bar')
    #
    # source://sidekiq//lib/sidekiq/client.rb#189
    def enqueue_to_in(queue, interval, klass, *args); end

    # source://sidekiq//lib/sidekiq/client.rb#159
    def push(item); end

    # source://sidekiq//lib/sidekiq/client.rb#163
    def push_bulk(items); end

    # Allows sharding of jobs across any number of Redis instances.  All jobs
    # defined within the block will use the given Redis connection pool.
    #
    #   pool = ConnectionPool.new { Redis.new }
    #   Sidekiq::Client.via(pool) do
    #     SomeJob.perform_async(1,2,3)
    #     SomeOtherJob.perform_async(1,2,3)
    #   end
    #
    # Generally this is only needed for very large Sidekiq installs processing
    # thousands of jobs per second.  I do not recommend sharding unless
    # you cannot scale any other way (e.g. splitting your app into smaller apps).
    #
    # source://sidekiq//lib/sidekiq/client.rb#149
    def via(pool); end
  end
end

# no difference for now
#
# source://sidekiq//lib/sidekiq/middleware/modules.rb#20
Sidekiq::ClientMiddleware = Sidekiq::ServerMiddleware

# Sidekiq::Config represents the global configuration for an instance of Sidekiq.
#
# source://sidekiq//lib/sidekiq/config.rb#8
class Sidekiq::Config
  extend ::Forwardable

  # @return [Config] a new instance of Config
  #
  # source://sidekiq//lib/sidekiq/config.rb#44
  def initialize(options = T.unsafe(nil)); end

  # source://forwardable/1.3.2/forwardable.rb#229
  def [](*args, **_arg1, &block); end

  # source://forwardable/1.3.2/forwardable.rb#229
  def []=(*args, **_arg1, &block); end

  # How frequently Redis should be checked by a random Sidekiq process for
  # scheduled and retriable jobs. Each individual process will take turns by
  # waiting some multiple of this value.
  #
  # See sidekiq/scheduled.rb for an in-depth explanation of this value
  #
  # source://sidekiq//lib/sidekiq/config.rb#205
  def average_scheduled_poll_interval=(interval); end

  # register a new queue processing subsystem
  #
  # @yield [cap]
  #
  # source://sidekiq//lib/sidekiq/config.rb#104
  def capsule(name); end

  # Returns the value of attribute capsules.
  #
  # source://sidekiq//lib/sidekiq/config.rb#53
  def capsules; end

  # @yield [@client_chain]
  #
  # source://sidekiq//lib/sidekiq/config.rb#87
  def client_middleware; end

  # source://sidekiq//lib/sidekiq/config.rb#61
  def concurrency; end

  # LEGACY: edits the default capsule
  # config.concurrency = 5
  #
  # source://sidekiq//lib/sidekiq/config.rb#57
  def concurrency=(val); end

  # Death handlers are called when all retries for a job have been exhausted and
  # the job dies.  It's the notification to your application
  # that this job will not succeed without manual intervention.
  #
  # Sidekiq.configure_server do |config|
  #   config.death_handlers << ->(job, ex) do
  #   end
  # end
  #
  # source://sidekiq//lib/sidekiq/config.rb#196
  def death_handlers; end

  # source://sidekiq//lib/sidekiq/config.rb#99
  def default_capsule(&block); end

  # Register a proc to handle any error which occurs within the Sidekiq process.
  #
  #   Sidekiq.configure_server do |config|
  #     config.error_handlers << proc {|ex,ctx_hash| MyErrorService.notify(ex, ctx_hash) }
  #   end
  #
  # The default error handler logs errors to @logger.
  #
  # source://sidekiq//lib/sidekiq/config.rb#216
  def error_handlers; end

  # source://forwardable/1.3.2/forwardable.rb#229
  def fetch(*args, **_arg1, &block); end

  # INTERNAL USE ONLY
  #
  # source://sidekiq//lib/sidekiq/config.rb#255
  def handle_exception(ex, ctx = T.unsafe(nil)); end

  # source://forwardable/1.3.2/forwardable.rb#229
  def has_key?(*args, **_arg1, &block); end

  # source://forwardable/1.3.2/forwardable.rb#229
  def key?(*args, **_arg1, &block); end

  # source://sidekiq//lib/sidekiq/config.rb#234
  def logger; end

  # source://sidekiq//lib/sidekiq/config.rb#245
  def logger=(logger); end

  # find a singleton
  #
  # source://sidekiq//lib/sidekiq/config.rb#179
  def lookup(name, default_class = T.unsafe(nil)); end

  # source://forwardable/1.3.2/forwardable.rb#229
  def merge!(*args, **_arg1, &block); end

  # source://sidekiq//lib/sidekiq/config.rb#129
  def new_redis_pool(size, name = T.unsafe(nil)); end

  # Register a block to run at a point in the Sidekiq lifecycle.
  # :startup, :quiet or :shutdown are valid events.
  #
  #   Sidekiq.configure_server do |config|
  #     config.on(:shutdown) do
  #       puts "Goodbye cruel world!"
  #     end
  #   end
  #
  # @raise [ArgumentError]
  #
  # source://sidekiq//lib/sidekiq/config.rb#228
  def on(event, &block); end

  # source://sidekiq//lib/sidekiq/config.rb#83
  def queues; end

  # Edit the default capsule.
  # config.queues = %w( high default low )                 # strict
  # config.queues = %w( high,3 default,2 low,1 )           # weighted
  # config.queues = %w( feature1,1 feature2,1 feature3,1 ) # random
  #
  # With weighted priority, queue will be checked first (weight / total) of the time.
  # high will be checked first (3/6) or 50% of the time.
  # I'd recommend setting weights between 1-10. Weights in the hundreds or thousands
  # are ridiculous and unnecessarily expensive. You can get random queue ordering
  # by explicitly setting all weights to 1.
  #
  # source://sidekiq//lib/sidekiq/config.rb#79
  def queues=(val); end

  # @raise [ArgumentError]
  #
  # source://sidekiq//lib/sidekiq/config.rb#151
  def redis; end

  # All capsules must use the same Redis configuration
  #
  # source://sidekiq//lib/sidekiq/config.rb#115
  def redis=(hash); end

  # source://sidekiq//lib/sidekiq/config.rb#135
  def redis_info; end

  # source://sidekiq//lib/sidekiq/config.rb#119
  def redis_pool; end

  # register global singletons which can be accessed elsewhere
  #
  # source://sidekiq//lib/sidekiq/config.rb#174
  def register(name, instance); end

  # @yield [@server_chain]
  #
  # source://sidekiq//lib/sidekiq/config.rb#93
  def server_middleware; end

  # source://sidekiq//lib/sidekiq/config.rb#65
  def total_concurrency; end

  private

  # source://sidekiq//lib/sidekiq/config.rb#123
  def local_redis_pool; end
end

# source://sidekiq//lib/sidekiq/config.rb#11
Sidekiq::Config::DEFAULTS = T.let(T.unsafe(nil), Hash)

# source://sidekiq//lib/sidekiq/config.rb#36
Sidekiq::Config::ERROR_HANDLER = T.let(T.unsafe(nil), Proc)

# source://sidekiq//lib/sidekiq/logger.rb#7
module Sidekiq::Context
  class << self
    # source://sidekiq//lib/sidekiq/logger.rb#20
    def add(k, v); end

    # source://sidekiq//lib/sidekiq/logger.rb#16
    def current; end

    # source://sidekiq//lib/sidekiq/logger.rb#8
    def with(hash); end
  end
end

# Include this module in your job class and you can easily create
# asynchronous jobs:
#
#   class HardJob
#     include Sidekiq::Job
#     sidekiq_options queue: 'critical', retry: 5
#
#     def perform(*args)
#       # do some work
#     end
#   end
#
# Then in your Rails app, you can do this:
#
#   HardJob.perform_async(1, 2, 3)
#
# Note that perform_async is a class method, perform is an instance method.
#
# Sidekiq::Job also includes several APIs to provide compatibility with
# ActiveJob.
#
#   class SomeJob
#     include Sidekiq::Job
#     queue_as :critical
#
#     def perform(...)
#     end
#   end
#
#   SomeJob.set(wait_until: 1.hour).perform_async(123)
#
# Note that arguments passed to the job must still obey Sidekiq's
# best practice for simple, JSON-native data types. Sidekiq will not
# implement ActiveJob's more complex argument serialization. For
# this reason, we don't implement `perform_later` as our call semantics
# are very different.
#
# source://sidekiq//lib/sidekiq/job.rb#44
module Sidekiq::Job
  include ::Sidekiq::Job::Options

  mixes_in_class_methods ::Sidekiq::Job::Options::ClassMethods
  mixes_in_class_methods ::Sidekiq::Job::ClassMethods

  # Returns the value of attribute jid.
  #
  # source://sidekiq//lib/sidekiq/job.rb#156
  def jid; end

  # Sets the attribute jid
  #
  # @param value the value to set the attribute jid to.
  #
  # source://sidekiq//lib/sidekiq/job.rb#156
  def jid=(_arg0); end

  # source://sidekiq//lib/sidekiq/job.rb#165
  def logger; end

  class << self
    # @private
    # @raise [ArgumentError]
    #
    # source://sidekiq//lib/sidekiq/job.rb#158
    def included(base); end
  end
end

# The Sidekiq testing infrastructure overrides perform_async
# so that it does not actually touch the network.  Instead it
# stores the asynchronous jobs in a per-class array so that
# their presence/absence can be asserted by your tests.
#
# This is similar to ActionMailer's :test delivery_method and its
# ActionMailer::Base.deliveries array.
#
# Example:
#
#   require 'sidekiq/testing'
#
#   assert_equal 0, HardJob.jobs.size
#   HardJob.perform_async(:something)
#   assert_equal 1, HardJob.jobs.size
#   assert_equal :something, HardJob.jobs[0]['args'][0]
#
# You can also clear and drain all job types:
#
#   Sidekiq::Job.clear_all # or .drain_all
#
# This can be useful to make sure jobs don't linger between tests:
#
#   RSpec.configure do |config|
#     config.before(:each) do
#       Sidekiq::Job.clear_all
#     end
#   end
#
# or for acceptance testing, i.e. with cucumber:
#
#   AfterStep do
#     Sidekiq::Job.drain_all
#   end
#
#   When I sign up as "foo@example.com"
#   Then I should receive a welcome email to "foo@example.com"
#
# source://sidekiq//lib/sidekiq/job.rb#268
module Sidekiq::Job::ClassMethods
  # source://sidekiq//lib/sidekiq/job.rb#371
  def build_client; end

  # @raise [ArgumentError]
  #
  # source://sidekiq//lib/sidekiq/job.rb#356
  def client_push(item); end

  # @raise [ArgumentError]
  #
  # source://sidekiq//lib/sidekiq/job.rb#269
  def delay(*args); end

  # @raise [ArgumentError]
  #
  # source://sidekiq//lib/sidekiq/job.rb#273
  def delay_for(*args); end

  # @raise [ArgumentError]
  #
  # source://sidekiq//lib/sidekiq/job.rb#277
  def delay_until(*args); end

  # source://sidekiq//lib/sidekiq/job.rb#289
  def perform_async(*args); end

  # +interval+ must be a timestamp, numeric or something that acts
  #   numeric (like an activesupport time interval).
  #
  # source://sidekiq//lib/sidekiq/job.rb#325
  def perform_at(interval, *args); end

  # Push a large number of jobs to Redis, while limiting the batch of
  # each job payload to 1,000. This method helps cut down on the number
  # of round trips to Redis, which can increase the performance of enqueueing
  # large numbers of jobs.
  #
  # +items+ must be an Array of Arrays.
  #
  # For finer-grained control, use `Sidekiq::Client.push_bulk` directly.
  #
  # Example (3 Redis round trips):
  #
  #     SomeJob.perform_async(1)
  #     SomeJob.perform_async(2)
  #     SomeJob.perform_async(3)
  #
  # Would instead become (1 Redis round trip):
  #
  #     SomeJob.perform_bulk([[1], [2], [3]])
  #
  # source://sidekiq//lib/sidekiq/job.rb#319
  def perform_bulk(*args, **kwargs); end

  # +interval+ must be a timestamp, numeric or something that acts
  #   numeric (like an activesupport time interval).
  #
  # source://sidekiq//lib/sidekiq/job.rb#325
  def perform_in(interval, *args); end

  # Inline execution of job's perform method after passing through Sidekiq.client_middleware and Sidekiq.server_middleware
  #
  # source://sidekiq//lib/sidekiq/job.rb#294
  def perform_inline(*args); end

  # Inline execution of job's perform method after passing through Sidekiq.client_middleware and Sidekiq.server_middleware
  #
  # source://sidekiq//lib/sidekiq/job.rb#294
  def perform_sync(*args); end

  # source://sidekiq//lib/sidekiq/job.rb#281
  def queue_as(q); end

  # source://sidekiq//lib/sidekiq/job.rb#285
  def set(options); end

  # Allows customization for this type of Job.
  # Legal options:
  #
  #   queue - use a named queue for this Job, default 'default'
  #   retry - enable the RetryJobs middleware for this Job, *true* to use the default
  #      or *Integer* count
  #   backtrace - whether to save any error backtrace in the retry payload to display in web UI,
  #      can be true, false or an integer number of lines to save, default *false*
  #   pool - use the given Redis connection pool to push this type of job to a given shard.
  #
  # In practice, any option is allowed.  This is the main mechanism to configure the
  # options for a specific job.
  #
  # source://sidekiq//lib/sidekiq/job.rb#352
  def sidekiq_options(opts = T.unsafe(nil)); end
end

# The Options module is extracted so we can include it in ActiveJob::Base
# and allow native AJs to configure Sidekiq features/internals.
#
# source://sidekiq//lib/sidekiq/job.rb#48
module Sidekiq::Job::Options
  mixes_in_class_methods ::Sidekiq::Job::Options::ClassMethods

  class << self
    # @private
    #
    # source://sidekiq//lib/sidekiq/job.rb#49
    def included(base); end
  end
end

# source://sidekiq//lib/sidekiq/job.rb#56
module Sidekiq::Job::Options::ClassMethods
  # source://sidekiq//lib/sidekiq/job.rb#84
  def get_sidekiq_options; end

  # source://sidekiq//lib/sidekiq/job.rb#88
  def sidekiq_class_attribute(*attrs); end

  # Allows customization for this type of Job.
  # Legal options:
  #
  #   queue - name of queue to use for this job type, default *default*
  #   retry - enable retries for this Job in case of error during execution,
  #      *true* to use the default or *Integer* count
  #   backtrace - whether to save any error backtrace in the retry payload to display in web UI,
  #      can be true, false or an integer number of lines to save, default *false*
  #
  # In practice, any option is allowed.  This is the main mechanism to configure the
  # options for a specific job.
  #
  # source://sidekiq//lib/sidekiq/job.rb#71
  def sidekiq_options(opts = T.unsafe(nil)); end

  # source://sidekiq//lib/sidekiq/job.rb#80
  def sidekiq_retries_exhausted(&block); end

  # source://sidekiq//lib/sidekiq/job.rb#76
  def sidekiq_retry_in(&block); end
end

# source://sidekiq//lib/sidekiq/job.rb#57
Sidekiq::Job::Options::ClassMethods::ACCESSOR_MUTEX = T.let(T.unsafe(nil), Thread::Mutex)

# This helper class encapsulates the set options for `set`, e.g.
#
#     SomeJob.set(queue: 'foo').perform_async(....)
#
# source://sidekiq//lib/sidekiq/job.rb#173
class Sidekiq::Job::Setter
  include ::Sidekiq::JobUtil

  # @return [Setter] a new instance of Setter
  #
  # source://sidekiq//lib/sidekiq/job.rb#176
  def initialize(klass, opts); end

  # source://sidekiq//lib/sidekiq/job.rb#194
  def perform_async(*args); end

  # +interval+ must be a timestamp, numeric or something that acts
  #   numeric (like an activesupport time interval).
  #
  # source://sidekiq//lib/sidekiq/job.rb#251
  def perform_at(interval, *args); end

  # source://sidekiq//lib/sidekiq/job.rb#240
  def perform_bulk(args, batch_size: T.unsafe(nil)); end

  # +interval+ must be a timestamp, numeric or something that acts
  #   numeric (like an activesupport time interval).
  #
  # source://sidekiq//lib/sidekiq/job.rb#251
  def perform_in(interval, *args); end

  # Explicit inline execution of a job. Returns nil if the job did not
  # execute, true otherwise.
  #
  # source://sidekiq//lib/sidekiq/job.rb#204
  def perform_inline(*args); end

  # Explicit inline execution of a job. Returns nil if the job did not
  # execute, true otherwise.
  #
  # source://sidekiq//lib/sidekiq/job.rb#204
  def perform_sync(*args); end

  # source://sidekiq//lib/sidekiq/job.rb#186
  def set(options); end

  private

  # source://sidekiq//lib/sidekiq/job.rb#258
  def at(interval); end
end

# source://sidekiq//lib/sidekiq/job_util.rb#5
module Sidekiq::JobUtil
  # @raise [ArgumentError]
  #
  # source://sidekiq//lib/sidekiq/job_util.rb#35
  def normalize_item(item); end

  # source://sidekiq//lib/sidekiq/job_util.rb#56
  def normalized_hash(item_class); end

  # @raise [ArgumentError]
  #
  # source://sidekiq//lib/sidekiq/job_util.rb#10
  def validate(item); end

  # source://sidekiq//lib/sidekiq/job_util.rb#18
  def verify_json(item); end

  private

  # @return [Boolean]
  #
  # source://sidekiq//lib/sidekiq/job_util.rb#67
  def json_safe?(item); end
end

# These functions encapsulate various job utilities.
#
# source://sidekiq//lib/sidekiq/job_util.rb#8
Sidekiq::JobUtil::TRANSIENT_ATTRIBUTES = T.let(T.unsafe(nil), Array)

# source://sidekiq//lib/sidekiq.rb#42
Sidekiq::LICENSE = T.let(T.unsafe(nil), String)

# source://sidekiq//lib/sidekiq/logger.rb#75
class Sidekiq::Logger < ::Logger
  include ::Sidekiq::LoggingUtils
end

# source://sidekiq//lib/sidekiq/logger.rb#78
module Sidekiq::Logger::Formatters; end

# source://sidekiq//lib/sidekiq/logger.rb#79
class Sidekiq::Logger::Formatters::Base < ::Logger::Formatter
  # source://sidekiq//lib/sidekiq/logger.rb#84
  def ctx; end

  # source://sidekiq//lib/sidekiq/logger.rb#88
  def format_context; end

  # source://sidekiq//lib/sidekiq/logger.rb#80
  def tid; end
end

# source://sidekiq//lib/sidekiq/logger.rb#114
class Sidekiq::Logger::Formatters::JSON < ::Sidekiq::Logger::Formatters::Base
  # source://sidekiq//lib/sidekiq/logger.rb#115
  def call(severity, time, program_name, message); end
end

# source://sidekiq//lib/sidekiq/logger.rb#102
class Sidekiq::Logger::Formatters::Pretty < ::Sidekiq::Logger::Formatters::Base
  # source://sidekiq//lib/sidekiq/logger.rb#103
  def call(severity, time, program_name, message); end
end

# source://sidekiq//lib/sidekiq/logger.rb#108
class Sidekiq::Logger::Formatters::WithoutTimestamp < ::Sidekiq::Logger::Formatters::Pretty
  # source://sidekiq//lib/sidekiq/logger.rb#109
  def call(severity, time, program_name, message); end
end

# source://sidekiq//lib/sidekiq/logger.rb#25
module Sidekiq::LoggingUtils
  # source://sidekiq//lib/sidekiq/logger.rb#39
  def debug?; end

  # source://sidekiq//lib/sidekiq/logger.rb#39
  def error?; end

  # source://sidekiq//lib/sidekiq/logger.rb#39
  def fatal?; end

  # source://sidekiq//lib/sidekiq/logger.rb#39
  def info?; end

  # source://sidekiq//lib/sidekiq/logger.rb#61
  def level; end

  # source://sidekiq//lib/sidekiq/logger.rb#44
  def local_level; end

  # source://sidekiq//lib/sidekiq/logger.rb#48
  def local_level=(level); end

  # Change the thread-local level for the duration of the given block.
  #
  # source://sidekiq//lib/sidekiq/logger.rb#66
  def log_at(level); end

  # source://sidekiq//lib/sidekiq/logger.rb#39
  def warn?; end
end

# source://sidekiq//lib/sidekiq/logger.rb#26
Sidekiq::LoggingUtils::LEVELS = T.let(T.unsafe(nil), Hash)

# source://sidekiq//lib/sidekiq/version.rb#5
Sidekiq::MAJOR = T.let(T.unsafe(nil), Integer)

# Middleware is code configured to run before/after
# a job is processed.  It is patterned after Rack
# middleware. Middleware exists for the client side
# (pushing jobs onto the queue) as well as the server
# side (when jobs are actually processed).
#
# Callers will register middleware Classes and Sidekiq will
# create new instances of the middleware for every job. This
# is important so that instance state is not shared accidentally
# between job executions.
#
# To add middleware for the client:
#
#   Sidekiq.configure_client do |config|
#     config.client_middleware do |chain|
#       chain.add MyClientHook
#     end
#   end
#
# To modify middleware for the server, just call
# with another block:
#
#   Sidekiq.configure_server do |config|
#     config.server_middleware do |chain|
#       chain.add MyServerHook
#       chain.remove ActiveRecord
#     end
#   end
#
# To insert immediately preceding another entry:
#
#   Sidekiq.configure_client do |config|
#     config.client_middleware do |chain|
#       chain.insert_before ActiveRecord, MyClientHook
#     end
#   end
#
# To insert immediately after another entry:
#
#   Sidekiq.configure_client do |config|
#     config.client_middleware do |chain|
#       chain.insert_after ActiveRecord, MyClientHook
#     end
#   end
#
# This is an example of a minimal server middleware:
#
#   class MyServerHook
#     include Sidekiq::ServerMiddleware
#
#     def call(job_instance, msg, queue)
#       logger.info "Before job"
#       redis {|conn| conn.get("foo") } # do something in Redis
#       yield
#       logger.info "After job"
#     end
#   end
#
# This is an example of a minimal client middleware, note
# the method must return the result or the job will not push
# to Redis:
#
#   class MyClientHook
#     include Sidekiq::ClientMiddleware
#
#     def call(job_class, msg, queue, redis_pool)
#       logger.info "Before push"
#       result = yield
#       logger.info "After push"
#       result
#     end
#   end
#
# source://sidekiq//lib/sidekiq/middleware/chain.rb#79
module Sidekiq::Middleware; end

# source://sidekiq//lib/sidekiq/middleware/chain.rb#80
class Sidekiq::Middleware::Chain
  include ::Enumerable

  # @api private
  # @return [Chain] a new instance of Chain
  # @yield [_self]
  # @yieldparam _self [Sidekiq::Middleware::Chain] the object that the method was called on
  #
  # source://sidekiq//lib/sidekiq/middleware/chain.rb#89
  def initialize(config = T.unsafe(nil)); end

  # Add the given middleware to the end of the chain.
  # Sidekiq will call `klass.new(*args)` to create a clean
  # copy of your middleware for every job executed.
  #
  #   chain.add(Statsd::Metrics, { collector: "localhost:8125" })
  #
  # @param klass [Class] Your middleware class
  # @param *args [Array<Object>] Set of arguments to pass to every instance of your middleware
  #
  # source://sidekiq//lib/sidekiq/middleware/chain.rb#119
  def add(klass, *args); end

  # source://sidekiq//lib/sidekiq/middleware/chain.rb#163
  def clear; end

  # source://sidekiq//lib/sidekiq/middleware/chain.rb#99
  def copy_for(capsule); end

  # Iterate through each middleware in the chain
  #
  # source://sidekiq//lib/sidekiq/middleware/chain.rb#84
  def each(&block); end

  # @return [Boolean] if the chain contains no middleware
  #
  # source://sidekiq//lib/sidekiq/middleware/chain.rb#155
  def empty?; end

  # source://sidekiq//lib/sidekiq/middleware/chain.rb#95
  def entries; end

  # @return [Boolean] if the given class is already in the chain
  #
  # source://sidekiq//lib/sidekiq/middleware/chain.rb#149
  def exists?(klass); end

  # @return [Boolean] if the given class is already in the chain
  #
  # source://sidekiq//lib/sidekiq/middleware/chain.rb#149
  def include?(klass); end

  # Inserts +newklass+ after +oldklass+ in the chain.
  # Useful if one middleware must run after another middleware.
  #
  # source://sidekiq//lib/sidekiq/middleware/chain.rb#141
  def insert_after(oldklass, newklass, *args); end

  # Inserts +newklass+ before +oldklass+ in the chain.
  # Useful if one middleware must run before another middleware.
  #
  # source://sidekiq//lib/sidekiq/middleware/chain.rb#132
  def insert_before(oldklass, newklass, *args); end

  # Used by Sidekiq to execute the middleware at runtime
  #
  # @api private
  #
  # source://sidekiq//lib/sidekiq/middleware/chain.rb#169
  def invoke(*args); end

  # Identical to {#add} except the middleware is added to the front of the chain.
  #
  # source://sidekiq//lib/sidekiq/middleware/chain.rb#125
  def prepend(klass, *args); end

  # Remove all middleware matching the given Class
  #
  # @param klass [Class]
  #
  # source://sidekiq//lib/sidekiq/middleware/chain.rb#107
  def remove(klass); end

  # source://sidekiq//lib/sidekiq/middleware/chain.rb#159
  def retrieve; end
end

# Represents each link in the middleware chain
#
# @api private
#
# source://sidekiq//lib/sidekiq/middleware/chain.rb#188
class Sidekiq::Middleware::Entry
  # @api private
  # @return [Entry] a new instance of Entry
  #
  # source://sidekiq//lib/sidekiq/middleware/chain.rb#191
  def initialize(config, klass, *args); end

  # @api private
  #
  # source://sidekiq//lib/sidekiq/middleware/chain.rb#189
  def klass; end

  # @api private
  #
  # source://sidekiq//lib/sidekiq/middleware/chain.rb#197
  def make_new; end
end

# source://sidekiq//lib/sidekiq.rb#41
Sidekiq::NAME = T.let(T.unsafe(nil), String)

# source://sidekiq//lib/sidekiq/rails.rb#7
class Sidekiq::Rails < ::Rails::Engine; end

# source://sidekiq//lib/sidekiq/rails.rb#8
class Sidekiq::Rails::Reloader
  # @return [Reloader] a new instance of Reloader
  #
  # source://sidekiq//lib/sidekiq/rails.rb#9
  def initialize(app = T.unsafe(nil)); end

  # source://sidekiq//lib/sidekiq/rails.rb#13
  def call; end

  # source://sidekiq//lib/sidekiq/rails.rb#19
  def inspect; end
end

# source://sidekiq//lib/sidekiq/redis_client_adapter.rb#7
class Sidekiq::RedisClientAdapter
  # @return [RedisClientAdapter] a new instance of RedisClientAdapter
  #
  # source://sidekiq//lib/sidekiq/redis_client_adapter.rb#66
  def initialize(options); end

  # source://sidekiq//lib/sidekiq/redis_client_adapter.rb#75
  def new_client; end

  private

  # source://sidekiq//lib/sidekiq/redis_client_adapter.rb#81
  def client_opts(options); end
end

# source://sidekiq//lib/sidekiq/redis_client_adapter.rb#8
Sidekiq::RedisClientAdapter::BaseError = RedisClient::Error

# source://sidekiq//lib/sidekiq/redis_client_adapter.rb#9
Sidekiq::RedisClientAdapter::CommandError = RedisClient::CommandError

# source://sidekiq//lib/sidekiq/redis_client_adapter.rb#0
class Sidekiq::RedisClientAdapter::CompatClient < ::RedisClient::Decorator::Client
  include ::Sidekiq::RedisClientAdapter::CompatMethods

  # source://sidekiq//lib/sidekiq/redis_client_adapter.rb#39
  def config; end

  # @yield [nil, @queue.pop]
  #
  # source://sidekiq//lib/sidekiq/redis_client_adapter.rb#43
  def message; end

  # NB: this method does not return
  #
  # source://sidekiq//lib/sidekiq/redis_client_adapter.rb#48
  def subscribe(chan); end
end

# source://sidekiq//lib/sidekiq/redis_client_adapter.rb#0
class Sidekiq::RedisClientAdapter::CompatClient::Pipeline < ::RedisClient::Decorator::Pipeline
  include ::Sidekiq::RedisClientAdapter::CompatMethods
end

# source://sidekiq//lib/sidekiq/redis_client_adapter.rb#11
module Sidekiq::RedisClientAdapter::CompatMethods
  # TODO Deprecate and remove this
  #
  # source://sidekiq//lib/sidekiq/redis_client_adapter.rb#18
  def evalsha(sha, keys, argv); end

  # TODO Deprecate and remove this
  #
  # source://sidekiq//lib/sidekiq/redis_client_adapter.rb#13
  def info; end

  private

  # this allows us to use methods like `conn.hmset(...)` instead of having to use
  # redis-client's native `conn.call("hmset", ...)`
  #
  # source://sidekiq//lib/sidekiq/redis_client_adapter.rb#26
  def method_missing(*args, **_arg1, &block); end

  # @return [Boolean]
  #
  # source://sidekiq//lib/sidekiq/redis_client_adapter.rb#31
  def respond_to_missing?(name, include_private = T.unsafe(nil)); end
end

# source://sidekiq//lib/sidekiq/redis_connection.rb#8
module Sidekiq::RedisConnection
  class << self
    # source://sidekiq//lib/sidekiq/redis_connection.rb#10
    def create(options = T.unsafe(nil)); end

    private

    # source://sidekiq//lib/sidekiq/redis_connection.rb#50
    def determine_redis_provider; end

    # source://sidekiq//lib/sidekiq/redis_connection.rb#29
    def scrub(options); end
  end
end

# Server-side middleware must import this Module in order
# to get access to server resources during `call`.
#
# source://sidekiq//lib/sidekiq/middleware/modules.rb#4
module Sidekiq::ServerMiddleware
  # Returns the value of attribute config.
  #
  # source://sidekiq//lib/sidekiq/middleware/modules.rb#5
  def config; end

  # Sets the attribute config
  #
  # @param value the value to set the attribute config to.
  #
  # source://sidekiq//lib/sidekiq/middleware/modules.rb#5
  def config=(_arg0); end

  # source://sidekiq//lib/sidekiq/middleware/modules.rb#10
  def logger; end

  # source://sidekiq//lib/sidekiq/middleware/modules.rb#14
  def redis(&block); end

  # source://sidekiq//lib/sidekiq/middleware/modules.rb#6
  def redis_pool; end
end

# We are shutting down Sidekiq but what about threads that
# are working on some long job?  This error is
# raised in jobs that have not finished within the hard
# timeout limit.  This is needed to rollback db transactions,
# otherwise Ruby's Thread#kill will commit.  See #377.
# DO NOT RESCUE THIS ERROR IN YOUR JOBS
#
# source://sidekiq//lib/sidekiq.rb#144
class Sidekiq::Shutdown < ::Interrupt; end

# source://sidekiq//lib/sidekiq/transaction_aware_client.rb#7
class Sidekiq::TransactionAwareClient
  # @return [TransactionAwareClient] a new instance of TransactionAwareClient
  #
  # source://sidekiq//lib/sidekiq/transaction_aware_client.rb#8
  def initialize(pool: T.unsafe(nil), config: T.unsafe(nil)); end

  # source://sidekiq//lib/sidekiq/transaction_aware_client.rb#12
  def push(item); end

  # We don't provide transactionality for push_bulk because we don't want
  # to hold potentially hundreds of thousands of job records in memory due to
  # a long running enqueue process.
  #
  # source://sidekiq//lib/sidekiq/transaction_aware_client.rb#24
  def push_bulk(items); end
end

# source://sidekiq//lib/sidekiq/version.rb#4
Sidekiq::VERSION = T.let(T.unsafe(nil), String)

# Sidekiq::Job is a new alias for Sidekiq::Worker as of Sidekiq 6.3.0.
# Use `include Sidekiq::Job` rather than `include Sidekiq::Worker`.
#
# The term "worker" is too generic and overly confusing, used in several
# different contexts meaning different things. Many people call a Sidekiq
# process a "worker". Some people call the thread that executes jobs a
# "worker". This change brings Sidekiq closer to ActiveJob where your job
# classes extend ApplicationJob.
#
# source://sidekiq//lib/sidekiq/worker_compatibility_alias.rb#12
Sidekiq::Worker = Sidekiq::Job
