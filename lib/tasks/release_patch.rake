namespace :release do
  desc "Bump patch version, bundle, commit, push master, build and push gem"
  task patch: :environment do
    ensure_clean_worktree!
    ensure_on_master!
    pull_master!

    version_file = File.expand_path("../jobler/version.rb", __dir__)
    current_version = read_version(version_file)
    next_version = bump_patch_version(current_version)

    update_version_file!(version_file, current_version, next_version)

    run_command!("bundle")

    run_command!("git add lib/jobler/version.rb")

    run_command!("git add Gemfile.lock") if File.exist?("Gemfile.lock")

    run_command!("git commit -m \"Release #{next_version}\"")
    run_command!("git push origin master")

    gem_file = "jobler-#{next_version}.gem"

    run_command!("gem build jobler.gemspec")
    run_command!("gem push #{gem_file}")
  end

  def run_command!(command)
    return if system(command)

    raise "Command failed: #{command}"
  end

  def ensure_clean_worktree!
    dirty_files = `git status --porcelain`

    return if dirty_files.strip.empty?

    raise "Working tree must be clean before release"
  end

  def ensure_on_master!
    current_branch = `git rev-parse --abbrev-ref HEAD`.strip

    return if current_branch == "master"

    raise "Releases must run from master (current: #{current_branch})"
  end

  def pull_master!
    run_command!("git pull --ff-only origin master")
  end

  def read_version(version_file)
    version_contents = File.read(version_file)
    matched_version = version_contents.match(/VERSION = "(\d+\.\d+\.\d+)"/)

    return matched_version[1] if matched_version

    raise "Could not find VERSION in #{version_file}"
  end

  def bump_patch_version(version)
    major, minor, patch = version.split(".").map(&:to_i)

    "#{major}.#{minor}.#{patch + 1}"
  end

  def update_version_file!(version_file, current_version, next_version)
    version_contents = File.read(version_file)
    updated_contents = version_contents.sub(
      "VERSION = \"#{current_version}\"",
      "VERSION = \"#{next_version}\""
    )

    File.write(version_file, updated_contents)
  end
end
