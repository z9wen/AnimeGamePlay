﻿using Cinemachine;
using UnityEngine;

namespace TaoTie
{
    public class TrackCameraPlugin : CameraPlugin<ConfigTrackCamera, TrackCameraStateData>
    {
        private Transform _lookAt;
        public CinemachineVirtualCamera camera => baseCamera as CinemachineVirtualCamera;
        public override CameraType type => CameraType.VirtualCameraPlugin;
        private CinemachineTrackedDolly _trackedDolly;
        private CinemachineHardLookAt _hardLookAt;
        private TrackCameraStateData _stateData => stateData as TrackCameraStateData;
        private bool _isPause;
        private Transform _tempPathObj;
        private Transform _focusTransform;
        private CinemachineSmoothPath _path;

        protected override void OnInitInternal(ConfigTrackCamera data)
        {
            base.OnInitInternal(data);
            baseCamera = obj.AddComponent<CinemachineVirtualCamera>();
            _lookAt = new GameObject($"{type}_LookAt_{id}").transform;
            _tempPathObj = new GameObject($"{type}_DollyTrack_{id}").transform;
            _lookAt.transform.parent = CameraManager.Instance.root;
            _tempPathObj.transform.parent = CameraManager.Instance.root;
            SetLookAtTransform(_lookAt);

            _trackedDolly = camera.GetCinemachineComponent<CinemachineTrackedDolly>();
            if (_trackedDolly == null)
                _trackedDolly = camera.AddCinemachineComponent<CinemachineTrackedDolly>();
            _hardLookAt = camera.GetCinemachineComponent<CinemachineHardLookAt>();
            if (_hardLookAt == null)
                _hardLookAt = camera.AddCinemachineComponent<CinemachineHardLookAt>();

            baseCamera.Priority = 0;
        }

        public override void OnEnter()
        {
            base.OnEnter();
            if (stateData != null)
                ChangeState(stateData);
            else
                ChangeState(new TrackCameraStateData(defaultConfig));
        }

        public override void OnLevel(bool clearState)
        {
            base.OnLevel(clearState);
            _isPause = true;
            _trackedDolly.m_Path = null;
            Object.Destroy(_path);
            _focusTransform = null;
        }

        public override void OnRelease()
        {
            baseCamera = null;
            Object.Destroy(_focusTransform);
            Object.Destroy(_lookAt);
            base.OnRelease();
        }

        protected override void ChangeStateInternal(TrackCameraStateData stateData)
        {
            base.ChangeStateInternal(stateData);
            camera.m_Lens.FieldOfView = stateData.fov;
            camera.m_Lens.Dutch = stateData.dutch;
            camera.m_Lens.FarClipPlane = stateData.farClipPlane;
            camera.m_Lens.NearClipPlane = stateData.nearClipPlane;
            _trackedDolly.enabled = true;
            _trackedDolly.m_XDamping = stateData.trackedDolly.xdamping;
            _trackedDolly.m_YDamping = stateData.trackedDolly.ydamping;
            _trackedDolly.m_ZDamping = stateData.trackedDolly.zdamping;
            SetFocusTransform(stateData.focusTrans, stateData.focusPosition);
            if (stateData.smoothRoute != null)
            {
                _path.m_Looped = stateData.smoothRoute.loop;
                _path.m_Resolution = stateData.smoothRoute.resolution;
                _path.m_Waypoints = stateData.smoothRoute.points;
                UpdatePosition();
                _isPause = stateData.smoothRoute.points.Length == 0;
            }
            else
            {
                _isPause = true;
            }
        }

        private void UpdatePosition()
        {
            _trackedDolly.m_PathPosition = _stateData.progress;
        }

        public override void Tick()
        {
            base.Tick();
            if (_isPause) return;
            _stateData.progress += Time.deltaTime;
            UpdatePosition();
        }

        /// <summary>
        /// 设置相对物体
        /// </summary>
        /// <param name="transform"></param>
        private void SetFocusTransform(Transform transform, Vector3 pos)
        {
            if (transform != null)
            {
                _focusTransform = transform;
                SetLookAtTransform(transform);
            }
            else
            {
                _focusTransform = _tempPathObj;
                _focusTransform.position = pos;
                _lookAt.position = pos;
                SetLookAtTransform(_lookAt);
            }

            _path = _focusTransform.gameObject.AddComponent<CinemachineSmoothPath>();
            _trackedDolly.m_Path = _path;
        }

        /// <summary>
        /// 设置暂停状态
        /// </summary>
        /// <param name="pause"></param>
        public void SetPauseState(bool pause)
        {
            _isPause = pause;
        }
    }
}