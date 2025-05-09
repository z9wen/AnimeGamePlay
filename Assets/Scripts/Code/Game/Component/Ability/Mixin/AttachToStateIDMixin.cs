﻿namespace TaoTie
{
    public class AttachToStateIDMixin : AbilityMixin<ConfigAttachToStateIDMixin>
    {

        private Fsm fsm;
        private bool hasAddModifier;
        private Entity owner;
        private AbilityComponent abilityComponent;

        protected override void InitInternal(ActorAbility actorAbility, ActorModifier actorModifier, ConfigAttachToStateIDMixin config)
        {
            owner = actorAbility.Parent.GetParent<Entity>();
            fsm = owner?.GetComponent<FsmComponent>()?.GetFsm(this.Config.ChargeLayer);
            abilityComponent = owner?.GetComponent<AbilityComponent>();
            if (fsm != null)
            {
                fsm.OnStateChanged += OnStateChanged;
                if (this.Config.StateIDs.Contains(fsm.CurrentStateName))
                {
                    ApplyModifier();
                }
            }
        }

        private void OnStateChanged(string from, string to)
        {
            if (Config.StateIDs == null || abilityComponent == null)
                return;

            bool flag = Config.StateIDs.Contains(from), flag2 = Config.StateIDs.Contains(to);
            if (!flag && flag2)
            {
                ApplyModifier();
            }
            else if (flag && !flag2)
            {
                RemoveModifier();
            }
        }

        private void ApplyModifier()
        {
            if (EvaluatePredicate())
            {
                abilityComponent.ApplyModifier(owner.Id, actorAbility, Config.ModifierName);
                hasAddModifier = true;
            }
        }

        private bool EvaluatePredicate()
        {
            if (Config.Predicate != null)
            {
                return Config.Predicate.Evaluate(owner, actorAbility, actorModifier, owner);
            }
            return true;
        }

        private void RemoveModifier()
        {
            if (hasAddModifier)
            {
                abilityComponent.RemoveModifier(actorAbility.Config.AbilityName, Config.ModifierName);
            }

            hasAddModifier = false;
        }

        protected override void DisposeInternal()
        {
            if (fsm != null)
            {
                fsm.OnStateChanged -= OnStateChanged;
                fsm = null;
            }

            hasAddModifier = false;
            abilityComponent = null;
            owner = null;
        }
    }
}