import * as AccessKeysClient from '@/resources/keys'
import { action, success, query, push, removeById, M, assignById } from 'vuexi'

const QUERY_ACCESS_KEYS = M.of('QUERY_ACCESS_KEYS')
const DELETE_ACCESS_KEYS = M.of('DELETE_ACCESS_KEYS')
const CREATE_ACCESS_KEY = M.of('CREATE_ACCESS_KEY')
const UPDATE_ACCESS_KEY = M.of('UPDATE_ACCESS_KEY')

export default {
  state: {
    keys: [],
    queryKeysError: null,
    isQueryKeysLoading: false,
    createKeyError: null,
    isCreateKeyLoading: false,
    deleteKeyError: null,
    isDeleteKeyLoading: false,
    updateKeyError: null,
    isUpdateKeyLoading: false
  },
  actions: {
    queryAccessKeys: query(QUERY_ACCESS_KEYS, AccessKeysClient.getAccessKeys),
    deleteAccessKey: query(DELETE_ACCESS_KEYS, AccessKeysClient.deleteAccessKey),
    updateAccessKey: query(UPDATE_ACCESS_KEY, AccessKeysClient.updateAccessKey),
    createAccessKey: query(CREATE_ACCESS_KEY, AccessKeysClient.createAccessKey)
  },
  mutations: {
    ...action(UPDATE_ACCESS_KEY, 'isUpdateKeyLoading', 'keys', 'updateKeyError', assignById),
    ...action(QUERY_ACCESS_KEYS, 'isQueryKeysLoading', 'keys', 'queryKeysError', success),
    ...action(DELETE_ACCESS_KEYS, 'isDeleteKeyLoading', 'keys', 'deleteKeyError', removeById),
    ...action(CREATE_ACCESS_KEY, 'isCreateKeyLoading', 'keys', 'createKeyError', push)
  }
}
