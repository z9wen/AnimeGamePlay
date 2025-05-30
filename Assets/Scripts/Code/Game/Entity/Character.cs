﻿using System.Collections.Generic;
using UnityEngine;

namespace TaoTie
{
    /// <summary>
    /// 非玩家角色
    /// </summary>
    public class Character:Actor,IEntity<int,uint>
    {
        #region IEntity

        public override EntityType Type => EntityType.Avatar;

        public void Init(int configId,uint campId)
        {
            CampId = campId;
            var avatar = AddComponent<AvatarComponent,int>(configId);
            ConfigId = avatar.Config.UnitId;
            configActor = GetActorConfig(Config.ActorConfig);
            if(configActor.Common!=null) LocalScale = Vector3.one * configActor.Common.Scale;
            AddComponent<AttachComponent>();
            AddComponent<UnitModelComponent,ConfigModel>(configActor.Model);
            AddComponent<NumericComponent,ConfigCombatProperty[]>(configActor.Combat?.DefaultProperty);
            AddComponent<FsmComponent,ConfigFsmController>(GetFsmConfig(Config.FSM));
            AddComponent<CombatComponent,ConfigCombat>(configActor.Combat);
            AddComponent<AvatarSkillComponent>();
            AddComponent<MoveComponent>();
            using ListComponent<ConfigAbility> list = ConfigAbilityCategory.Instance.GetList(configActor.Abilities);
            AddComponent<AbilityComponent,List<ConfigAbility>>(list);
            AddComponent<EquipHoldComponent>();
        }
        

        public void Destroy()
        {
            configActor = null;
            ConfigId = default;
            CampId = 0;
        }

        #endregion
        
    }
}