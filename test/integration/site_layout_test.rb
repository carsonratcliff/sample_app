require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
   
   test "layout links" do
    # 5.32
     get root_path
     assert_template 'static_pages/home'
     assert_select "a[href=?]", root_path, count: 2
     assert_select "a[href=?]", help_path
     assert_select "a[href=?]", about_path
     assert_select "a[href=?]", contact_path
     # 5.36
     get contact_path
     assert_select "title", full_title("Contact")
   end
end
