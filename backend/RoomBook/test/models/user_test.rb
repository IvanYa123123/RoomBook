require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid fixture" do
    assert users(:guest_user).valid?
  end

  test "requires unique email case-insensitively" do
    duplicate = User.new(
      email: "GUEST@EXAMPLE.COM", first_name: "Пётр",
      password: "password123", password_confirmation: "password123", role: :guest
    )
    assert_not duplicate.valid?
  end

  test "normalizes email" do
    user = User.create!(
      email: "  NewUser@Example.COM ", first_name: "Новый",
      password: "password123", password_confirmation: "password123", role: :guest
    )
    assert_equal "newuser@example.com", user.reload.email
  end

  test "rejects short password" do
    user = User.new(email: "short@example.com", first_name: "Тест",
                    password: "short", password_confirmation: "short", role: :guest)
    assert_not user.valid?
  end

  test "role helpers" do
    assert users(:guest_user).guest?
    assert users(:host_user).host?
  end
end
