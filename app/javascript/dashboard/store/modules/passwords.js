import * as PasswordsClient from '@/resources/passwords'
import { action, query, silence, M } from 'vuexi'

const FORGET_PASSWORD = M.of('FORGET_PASSWORD')

export default {
  state: {
    isForgetPasswordLoading: false,
    forgetPasswordError: null
  },
  actions: {
    forgetPassword: query(FORGET_PASSWORD, PasswordsClient.forgetPassword)
  },
  mutations: {
    ...action(FORGET_PASSWORD, 'isForgetPasswordLoading', '', 'forgetPasswordError', silence)
  }
}
