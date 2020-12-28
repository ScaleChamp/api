import * as SessionsClient from '@/resources/sessions'
import * as PasswordsClient from '@/resources/passwords'
import * as OtpClient from '@/resources/otp'
import { action, success, query, commit, nil, set, M } from 'vuexi'
import * as ProfileClient from '@/resources/profile'

const metaUser = document.querySelector('meta[name="user"]')
const data = decodeURIComponent(metaUser.content)
const user = JSON.parse(data)

const LOGOUT = 'LOGOUT'
const REFRESH = 'REFRESH'
const LOGIN = M.of('LOGIN')
const VERIFY = M.of('VERIFY')
const SIGNUP = M.of('SIGNUP')
const RECOVER_PASSWORD = M.of('RECOVER_PASSWORD')
const UPDATE_EMAIL = M.of('UPDATE_EMAIL')
const DISABLE_OTP = M.of('DISABLE_OTP')
const UPDATE_USER = M.of('UPDATE_USER')
const CONFIRM_OTP = M.of('CONFIRM_OTP')
const QUERY_PROFILE = M.of('QUERY_PROFILE')
const DESTROY_PROFILE = M.of('DESTROY_PROFILE')

export default {
  state: {
    user,
    loginError: null,
    isLoginLoading: false,
    isSignUpLoading: false,
    signUpError: null,
    isRecoverPasswordLoading: false,
    recoverPasswordError: null,
    verifyError: null,
    isVerifyLoading: false,
    updateEmailError: null,
    isUpdateEmailLoading: false,
    confirmOtpError: null,
    isConfirmOtpLoading: false,
    isProfileLoading: false,
    profileError: null,
    isDestroyProfileLoading: false,
    destroyProfileError: null,
    isUpdateUserLoading: false,
    updateUserError: null
  },
  actions: {
    refresh: commit(REFRESH),
    verify: query(VERIFY, SessionsClient.login),
    confirmOtp: query(CONFIRM_OTP, OtpClient.confirmOtp),
    disableOtp: query(CONFIRM_OTP, OtpClient.disableOtp),
    login: query(LOGIN, SessionsClient.login),
    signup: query(SIGNUP, SessionsClient.signup),
    updateEmail: query(UPDATE_EMAIL, SessionsClient.changeEmail),
    updateUser: query(UPDATE_USER, SessionsClient.updateUser),
    logout: commit(LOGOUT),
    recoverPassword: query(RECOVER_PASSWORD, PasswordsClient.recoverPassword),
    queryProfile: query(QUERY_PROFILE, ProfileClient.getProfile),
    destroyProfile: query(DESTROY_PROFILE, ProfileClient.destroyProfile)
  },
  mutations: {
    [REFRESH]: set('user'),
    [LOGOUT]: nil('user'),
    ...action(DESTROY_PROFILE, 'isDestroyProfileLoading', 'user', 'destroyProfileError', success),
    ...action(QUERY_PROFILE, 'isProfileLoading', 'user', 'profileError', success),
    ...action(DISABLE_OTP, 'isConfirmOtpLoading', 'user', 'confirmOtpError', success),
    ...action(CONFIRM_OTP, 'isConfirmOtpLoading', 'user', 'confirmOtpError', success),
    ...action(SIGNUP, 'isSignUpLoading', 'user', 'signUpError', success),
    ...action(LOGIN, 'isLoginLoading', 'user', 'loginError', success),
    ...action(RECOVER_PASSWORD, 'isRecoverPasswordLoading', 'user', 'recoverPasswordError', success),
    ...action(VERIFY, 'isVerifyLoading', 'user', 'verifyError', success),
    ...action(UPDATE_EMAIL, 'isUpdateEmailLoading', 'user', 'updateEmailError', success),
    ...action(UPDATE_USER, 'isUpdateUserLoading', 'user', 'updateUserError', success)
  }
}
