class UserSerializer < BaseSerializer
  def self.call(user)
    {
      id: user.id,
      email: user.email,
      firstName: user.first_name,
      lastName: user.last_name,
      fullName: user.full_name,
      role: user.role
    }
  end
end
