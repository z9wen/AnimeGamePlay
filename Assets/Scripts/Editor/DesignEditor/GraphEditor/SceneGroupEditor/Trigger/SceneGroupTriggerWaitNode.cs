using DaGenGraph;
using Sirenix.OdinInspector;
using UnityEngine;

namespace TaoTie
{
    public class SceneGroupTriggerWaitNode: JsonNodeBase
    {
        [MinValue(1)]
        [LabelText("延迟时间（ms）")]
        public long Delay = 1;
        
        [LabelText("是否现实世界时间")]
        public bool IsRealTime;
        public override void AddDefaultPorts()
        {
            AddInputPort<SceneGroupActionPort>("执行", EdgeMode.Multiple, false, EdgeType.Both, false);
            AddOutputPort<SceneGroupActionPort>("当等待后", EdgeMode.Multiple, false, EdgeType.Both, false);
        }
    }
}