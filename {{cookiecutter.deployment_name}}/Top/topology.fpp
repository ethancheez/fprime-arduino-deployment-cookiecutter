module {{cookiecutter.deployment_name}} {

  # ----------------------------------------------------------------------
  # Symbolic constants for port numbers
  # ----------------------------------------------------------------------

    enum Ports_RateGroups {
      rateGroup1
    }

  topology {{cookiecutter.deployment_name}} {

    # ----------------------------------------------------------------------
    # Instances used in the topology
    # ----------------------------------------------------------------------

    instance bufferManager
    instance cmdDisp
    instance comQueue
    instance comStub
    instance commDriver
    instance deframer
    instance eventLogger
    instance fatalHandler
    instance framer
    instance fprimeRouter
    instance frameAccumulator
{%- if cookiecutter.file_system_type in ["SD_Card", "MicroFS"] %}
    instance fileDownlink
    instance fileManager
    instance fileUplink
    instance prmDb
{%- endif %}
    instance rateDriver
    instance rateGroup1
    instance rateGroupDriver
    instance systemResources
    instance textLogger
    instance timeHandler
    instance tlmSend

    # ----------------------------------------------------------------------
    # Pattern graph specifiers
    # ----------------------------------------------------------------------

    command connections instance cmdDisp

    event connections instance eventLogger
{% if cookiecutter.file_system_type in ["SD_Card", "MicroFS"] %}
    param connections instance prmDb
{%- endif %}

    telemetry connections instance tlmSend

    text event connections instance textLogger

    time connections instance timeHandler

    # ----------------------------------------------------------------------
    # Direct graph specifiers
    # ----------------------------------------------------------------------

    connections RateGroups {
      # Block driver
      rateDriver.CycleOut -> rateGroupDriver.CycleIn

      # Rate group 1
      rateGroupDriver.CycleOut[Ports_RateGroups.rateGroup1] -> rateGroup1.CycleIn
      rateGroup1.RateGroupMemberOut[0] -> tlmSend.Run
      rateGroup1.RateGroupMemberOut[1] -> systemResources.run
      rateGroup1.RateGroupMemberOut[2] -> commDriver.schedIn
{%- if cookiecutter.file_system_type in ["SD_Card", "MicroFS"] %}
      rateGroup1.RateGroupMemberOut[3] -> fileDownlink.Run
{%- endif %}
    }

    connections FaultProtection {
      eventLogger.FatalAnnounce -> fatalHandler.FatalReceive
    }

    connections Downlink {
      # Inputs to ComQueue (events, telemetry, file)
      eventLogger.PktSend -> comQueue.comPacketQueueIn[0]
      tlmSend.PktSend     -> comQueue.comPacketQueueIn[1]
{%- if cookiecutter.file_system_type in ["SD_Card", "MicroFS"] %}
      fileDownlink.bufferSendOut  -> comQueue.bufferQueueIn[0]
      comQueue.bufferReturnOut[0] -> fileDownlink.bufferReturn
{%- endif %}

      # ComQueue <-> Framer
      comQueue.dataOut     -> framer.dataIn
      framer.dataReturnOut -> comQueue.dataReturnIn
      framer.comStatusOut  -> comQueue.comStatusIn

      # Buffer Management for Framer
      framer.bufferAllocate   -> bufferManager.bufferGetCallee
      framer.bufferDeallocate -> bufferManager.bufferSendIn

      # Framer <-> ComStub
      framer.dataOut        -> comStub.dataIn
      comStub.dataReturnOut -> framer.dataReturnIn
      comStub.comStatusOut  -> framer.comStatusIn

      # ComStub <-> CommDriver
      comStub.drvSendOut       -> commDriver.$send
      commDriver.sendReturnOut -> comStub.drvSendReturnIn
      commDriver.ready         -> comStub.drvConnected
    }
    
    connections Uplink {
      # CommDriver buffer allocations
      commDriver.allocate   -> bufferManager.bufferGetCallee
      commDriver.deallocate -> bufferManager.bufferSendIn

      # CommDriver <-> ComStub
      commDriver.$recv            -> comStub.drvReceiveIn
      comStub.drvReceiveReturnOut -> commDriver.recvReturnIn

      # ComStub <-> FrameAccumulator
      comStub.dataOut                -> frameAccumulator.dataIn
      frameAccumulator.dataReturnOut -> comStub.dataReturnIn

      # FrameAccumulator buffer allocations
      frameAccumulator.bufferDeallocate -> bufferManager.bufferSendIn
      frameAccumulator.bufferAllocate   -> bufferManager.bufferGetCallee

      # FrameAccumulator <-> Deframer
      frameAccumulator.dataOut  -> deframer.dataIn
      deframer.dataReturnOut    -> frameAccumulator.dataReturnIn

      # Deframer <-> Router
      deframer.dataOut           -> fprimeRouter.dataIn
      fprimeRouter.dataReturnOut -> deframer.dataReturnIn

      # Router buffer allocations
      fprimeRouter.bufferAllocate   -> bufferManager.bufferGetCallee
      fprimeRouter.bufferDeallocate -> bufferManager.bufferSendIn

      # Router <-> CmdDispatcher/FileUplink
      fprimeRouter.commandOut  -> cmdDisp.seqCmdBuff
      cmdDisp.seqCmdStatus     -> fprimeRouter.cmdResponseIn
{%- if cookiecutter.file_system_type in ["SD_Card", "MicroFS"] %}
      fprimeRouter.fileOut     -> fileUplink.bufferSendIn
      fileUplink.bufferSendOut -> fprimeRouter.fileBufferReturnIn
{%- endif %}
    }

    connections {{cookiecutter.deployment_name}} {
      # Add here connections to user-defined components
    }

  }

}
