﻿using Nino.Core;
using Sirenix.OdinInspector;

namespace TaoTie
{
    [NinoType(false)]
    public partial class AddAbility: ConfigAbilityAction
    {
        [NinoMember(10)]
#if UNITY_EDITOR
        [ValueDropdown("@"+nameof(OdinDropdownHelper)+"."+nameof(OdinDropdownHelper.GetAbilities)+"()",AppendNextDrawer = true)]
#endif
        public string AbilityName;
        protected override void Execute(Entity actionExecuter, ActorAbility ability, ActorModifier modifier, Entity target)
        {
            var ac = target.GetComponent<AbilityComponent>();
            if (ac != null)
            {
                var config = ConfigAbilityCategory.Instance.Get(AbilityName);
                if (config != null)
                    ac.AddAbility(config);
            }
        }
    }
}