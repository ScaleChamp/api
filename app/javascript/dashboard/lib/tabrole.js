export function tabByRole (role, newService) {
  switch (role) {
    case 'member':
      return `services`
    case 'administrator':
    case 'owner':
      if (newService) {
        return 'new-instance'
      }
      return `services`
    default:
      return `billing`
  }
}
