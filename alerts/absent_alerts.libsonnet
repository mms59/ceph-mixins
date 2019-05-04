{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'ceph-absent',
        rules: [
          {
            alert: 'CephMgrIsAbsent',
            expr: |||
              absent(up{%(cephExporterSelector)s} == 1)
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Storage metrics collector service not available anymore.',
              description: 'Ceph Manager has disappeared from Prometheus target discovery.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
        ],
      },
      {
        name: 'ceph-down',
        rules: [
          {
            alert: 'CephMgrIsMissingReplicas',
            expr: |||
              sum(up{%(cephExporterSelector)s}) != %(cephMgrCount)d
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Storage metrics collector service not available anymore.',
              description: 'Ceph Manager is missing replicas.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
        ],
      },
    ],
  },
}