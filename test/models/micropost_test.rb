require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # 13.4 - Tests for validity of new micropost
  def setup
    @user = users(:michael)
    # 13.12 - Idiomatically correct code to buil microposts
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  # 13.7 - Putting the Micro in Micropost
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  # 13.14 - Micropost order, most recent is first
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

end
