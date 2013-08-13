class BranchedDeploy
  def prompt
    begin
      branch = ask
    end while invalid? branch
    branch
  end

  private

  # => * Type branch name to deploy: (master, feature_1) |master|
  def ask
    Capistrano::CLI.ui.ask("  * Type branch name to deploy (#{git_all_branches_and_tags}):") { |q| q.default = git_branch.current }
  end

  def invalid?(branch)
    puts (!branch_or_tag_exist? branch).inspect
    !branch_or_tag_exist? branch
  end

  def git_branch
    @git_branch ||= GitBranch.new
  end

  def git_tag
    @git_tag ||= GitTag.new
  end

  def git_all_branches_and_tags
    ["branches: ", git_branch.all, "tags: ", git_tag.all].flatten.join(', ')
  end

  def branch_or_tag_exist?(branch)
    git_branch.exists?(branch) || git_tag.exists?(branch)
  end


  class GitBranch
    def current
      branches.detect { |branch| branch.start_with? "*" }[2..-1]
    end

    def all
      branches.collect(&removing_asterisk_from_current_branch)
    end

    def exists?(branch)
      all.include? branch
    end

    private

    # => ["* master", "feature_1"]
    def branches
      @branches ||= `git branch`.split("\n").map(&:strip)
    end

    def removing_asterisk_from_current_branch
      lambda { |branch| branch.gsub(/^\* /,"") }
    end
  end


  class GitTag
    def all
      tags.collect(&removing_asterisk_from_current_tag)
    end

    def exists?(tag)
      all.include? tag
    end

    private

    def tags
      @tags ||= `git tag`.split("\n").map(&:strip)
    end

    def removing_asterisk_from_current_tag
      lambda { |tag| tag.gsub(/^\* /,"") }
    end
  end
end
