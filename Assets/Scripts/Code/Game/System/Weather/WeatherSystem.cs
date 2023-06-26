﻿using System.Collections.Generic;

namespace TaoTie
{
    public class WeatherSystem: IManager, IUpdate
    {
        //游戏世界一天时间，换算成GameTime的总时长，下同
        const int mDayTimeCount = 1200000;
        //早上开始时间
        const int mMorningTimeStart = 0;
        //中午开始时间
        const int mNoonTimeStart = 100000;
        //下午开始时间
        const int mAfterNoonTimeStart = 700000;
        //晚上开始时间
        const int mNightTimeStart = 800000;
        
        private PriorityStack<EnvironmentRunner> envInfoStack;
        private Dictionary<long, EnvironmentRunner> envInfoMap;

        private EnvironmentRunner curRunner;
        private EnvironmentInfo preInfo;
        private EnvironmentInfo curInfo;

        public ConfigBlender DefaultEasing;
        
        public int DayTimeCount{ get; private set; }
        public int MorningTimeStart { get; private set; }
        public int NoonTimeStart{ get; private set; }
        public int AfterNoonTimeStart{ get; private set; }
        public int NightTimeStart{ get; private set; }
        public long NowTime{ get; private set; }
        
        public bool InWater { get; set; }
        
        #region IManager
        
        public void Init()
        {
            envInfoStack = new PriorityStack<EnvironmentRunner>();
            envInfoMap = new Dictionary<long, EnvironmentRunner>();

            DayTimeCount = mDayTimeCount;
            MorningTimeStart = mMorningTimeStart;
            NoonTimeStart = mNoonTimeStart;
            AfterNoonTimeStart = mAfterNoonTimeStart;
            NightTimeStart = mNightTimeStart;
            NowTime = GameTimerManager.Instance.GetTimeNow();

            DefaultEasing = new ConfigBlender();
        }

        public void Destroy()
        {
            foreach (var item in envInfoMap)
            {
                item.Value.Dispose();
            }
            envInfoStack = null;
            envInfoMap = null;
            DefaultEasing = null;
        }
        
        public void Update()
        {
            NowTime = GameTimerManager.Instance.GetTimeNow();
            NowTime %= DayTimeCount;
            foreach (var item in envInfoStack)
            {
                item.Update();
            }
            if (envInfoStack.Count == 0) return;
            var top = envInfoStack.Peek();
            if (curRunner != top)//栈顶环境变更，需要变换
            {
                if (curRunner == null)
                {
                    curRunner = top;
                    return;
                }
                if (top is BlenderEnvironmentRunner blender) //正在变换
                {
                    return;
                    // 中途改变这种，天空盒插值不了，得等正在变换的变换完
                    // envInfoStack.Pop();
                    // while (envInfoStack.Peek().IsOver) //移除已经over的
                    // {
                    //     envInfoStack.Pop().Dispose();
                    // }
                    //
                    // var newTop = envInfoStack.Peek();
                    // blender.ChangeTo(newTop as NormalEnvironmentRunner, false);
                    // envInfoStack.Push(blender);
                }
                else//变换到下一个环境
                {
                    while (envInfoStack.Peek().IsOver)//移除已经over的
                    {
                        envInfoStack.Pop().Dispose();
                    }
                    blender = CreateRunner(curRunner as NormalEnvironmentRunner, envInfoStack.Peek() as NormalEnvironmentRunner,
                        false);
                    envInfoStack.Push(blender);
                    curRunner = blender;
                }
            }
            else if (top.IsOver) //播放完毕，需要变换环境
            {
                if (top is BlenderEnvironmentRunner blender) //正在变换
                {
                    envInfoStack.Pop();
                    while (envInfoStack.Peek().IsOver) //移除已经over的
                    {
                        envInfoStack.Pop().Dispose();
                    }

                    var newTop = envInfoStack.Peek();
                    if (blender.To.Id == newTop.Id) //是变换完成了
                    {
                        curRunner = envInfoStack.Peek();
                        top.Dispose();
                    }
                    else //变换时，目标环境改变，需要变换到新的环境
                    {
                        blender.ChangeTo(newTop as NormalEnvironmentRunner, false);
                        envInfoStack.Push(blender);
                    }
                }
                else //一般环境被销毁，需要出栈，变换到下一个环境
                {
                    envInfoStack.Pop();
                    while (envInfoStack.Peek().IsOver) //移除已经over的
                    {
                        envInfoStack.Pop().Dispose();
                    }

                    blender = CreateRunner(top as NormalEnvironmentRunner, envInfoStack.Peek() as
                        NormalEnvironmentRunner, false);
                    envInfoStack.Push(blender);
                    curRunner = blender;
                }
            }
            
            if (curRunner != null)
            {
                ApplyEnvironmentInfo(curRunner.Data);
            }
            else
            {
                ApplyEnvironmentInfo(null);
            }
        }
        #endregion
        private void ApplyEnvironmentInfo(EnvironmentInfo info)
        {
            preInfo = curInfo;
            curInfo = info;
            if (preInfo == curInfo && (info == null || !info.Changed)) return;
            
            //todo:
        }

        private NormalEnvironmentRunner CreateRunner(EnvironmentConfig data, EnvironmentPriorityType type)
        {
            NormalEnvironmentRunner runner = NormalEnvironmentRunner.Create(data, type, this);
            envInfoMap.Add(runner.Id,runner);
            return runner;
        }
        
        private BlenderEnvironmentRunner CreateRunner(NormalEnvironmentRunner from, NormalEnvironmentRunner to,
            bool isEnter)
        {
            BlenderEnvironmentRunner runner = BlenderEnvironmentRunner.Create(from, to, isEnter, this);
            envInfoMap.Add(runner.Id,runner);
            return runner;
        }
        
        private DayEnvironmentRunner CreateRunner(EnvironmentConfig morning,EnvironmentConfig noon,EnvironmentConfig afternoon,
            EnvironmentConfig night,EnvironmentPriorityType priority)
        {
            DayEnvironmentRunner runner = DayEnvironmentRunner.Create(morning, noon,afternoon,night,priority,this);
            envInfoMap.Add(runner.Id,runner);
            return runner;
        }
        
        /// <summary>
        /// 创建环境
        /// </summary>
        /// <param name="data"></param>
        /// <param name="priority"></param>
        public long Create(EnvironmentConfig data, EnvironmentPriorityType priority)
        {
            var res = CreateRunner(data, priority);
            envInfoStack.Push(res);
            return res.Id;
        }
        /// <summary>
        /// 创建日夜循环环境
        /// </summary>
        public long CreateDayNight(EnvironmentConfig morning,EnvironmentConfig noon,EnvironmentConfig afternoon,
            EnvironmentConfig night, EnvironmentPriorityType priority = EnvironmentPriorityType.DayNight)
        {
            var res = CreateRunner(morning, noon,afternoon,night,priority);
            envInfoStack.Push(res);
            return res.Id;
        }

        /// <summary>
        /// 移除环境
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool Remove(long id)
        {
            if (envInfoMap.TryGetValue(id, out var info) && info.IsOver)
            {
                info.IsOver = true;
                
                //非生效环境
                if (curRunner is BlenderEnvironmentRunner blender)
                {
                    if (blender.To.Id != info.Id)
                    {
                        envInfoStack.Remove(info);
                        info.Dispose();
                    }
                }
                else if(curRunner.Id != info.Id)
                {
                    envInfoStack.Remove(info);
                    info.Dispose();
                }
                
                return true;
            }
            return false;
        }

        /// <summary>
        /// 从索引中删除，请不要手动调用
        /// </summary>
        /// <param name="id"></param>
        public void RemoveFromMap(long id)
        {
            envInfoMap.Remove(id);
        }
    }
}