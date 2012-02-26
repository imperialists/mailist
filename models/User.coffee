mongoose = require 'mongoose'
mongooseAuth = require 'mongoose-auth'

UserSchema = new mongoose.Schema(
  subscriptions: [String]
  pins: [{ type: mongoose.Schema.ObjectId, ref: 'Thread' }]
)

UserSchema.plugin mongooseAuth,
  everymodule:
    everyauth:
      User: ->
        User

  password:
    loginWith: 'email'

    extraParams:
      name:
        first: String
        last: String
      email: String

    everyauth:
      getLoginPath: "/login"
      postLoginPath: "/login"
      loginView: "login.jade"
      getRegisterPath: "/register"
      postRegisterPath: "/register"
      registerView: "register.jade"
      loginSuccessRedirect: "/"
      registerSuccessRedirect: "/"

User = mongoose.model 'User', UserSchema
module.exports = User
