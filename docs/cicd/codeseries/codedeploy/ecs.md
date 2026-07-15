# CodeDeploy
## ECS
### Blue/Green
```bash
version: 0.0
Resources:
  - TargetService:
      Type: AWS::ECS::Service
      Properties:
        TaskDefinition: <TASK_DEFINITION>
        LoadBalancerInfo:
          ContainerName: app-name
          ContainerPort: 3000
```