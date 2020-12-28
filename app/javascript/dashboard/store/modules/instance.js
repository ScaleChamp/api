import * as InstancesClient from '@/resources/instances'
import { action, success, query, cached, poll, silence, commit, assign, M } from 'vuexi'

const UPDATE_STATE = 'UPDATE_STATE'
const QUERY_INSTANCE = M.of('QUERY_INSTANCE')
const UPGRADE_INSTANCE = M.of('UPGRADE_INSTANCE')
const EDIT_FIREWALL = M.of('EDIT_FIREWALL')
const EDIT_PASSWORD = M.of('EDIT_PASSWORD')
const DESTROY_INSTANCE = M.of('DESTROY_INSTANCE')
const CREATE_INSTANCE = M.of('CREATE_INSTANCE')

export default {
  state: {
    instance: null,

    isQueryInstanceLoading: false,
    queryInstanceError: null,

    isCreateInstanceLoading: false,
    createInstanceError: null,

    isQueryEditPasswordLoading: false,
    queryEditPasswordError: null,

    isUpgradeInstanceLoading: false,
    upgradeInstanceError: null,

    isDestroyInstanceLoading: false,
    destroyInstanceError: null,

    isEditFirewallInstanceLoading: false,
    editFirewallInstanceError: null
  },
  actions: {
    createInstance: query(CREATE_INSTANCE, InstancesClient.createInstance),
    queryInstance: cached(QUERY_INSTANCE, InstancesClient.getInstance, 'instances', 'instances'),
    queryInstanceDirectly: query(QUERY_INSTANCE, InstancesClient.getInstance),
    pollInstance: poll(QUERY_INSTANCE, InstancesClient.getInstance),
    updateState: commit(UPDATE_STATE),
    destroyInstance: query(DESTROY_INSTANCE, InstancesClient.destroyInstance),
    upgradeInstance: query(UPGRADE_INSTANCE, InstancesClient.updateInstance),
    editPassword: query(EDIT_PASSWORD, InstancesClient.updateInstance),
    editFirewall: query(EDIT_FIREWALL, InstancesClient.updateInstance)
  },
  mutations: {
    [UPDATE_STATE]: assign('instance'),
    ...action(UPGRADE_INSTANCE, 'isUpgradeInstanceLoading', 'instance', 'upgradeInstanceError', success),
    ...action(EDIT_FIREWALL, 'isEditFirewallInstanceLoading', 'instance', 'editFirewallInstanceError', success),
    ...action(QUERY_INSTANCE, 'isQueryInstanceLoading', 'instance', 'queryInstanceError', success),
    ...action(EDIT_PASSWORD, 'isQueryEditPasswordLoading', 'instance', 'queryEditPasswordError', success),
    ...action(DESTROY_INSTANCE, 'isDestroyInstanceLoading', 'instance', 'destroyInstanceError', silence),
    ...action(CREATE_INSTANCE, 'isCreateInstanceLoading', 'instance', 'createInstanceError', success)
  }
}
