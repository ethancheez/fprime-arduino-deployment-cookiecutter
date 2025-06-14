module {{cookiecutter.deployment_name}} {

  # ----------------------------------------------------------------------
  # Defaults
  # ----------------------------------------------------------------------

  module Default {
    constant QUEUE_SIZE = 3
    constant STACK_SIZE = 64 * 1024
  }

  # ----------------------------------------------------------------------
  # Active component instances
  # ----------------------------------------------------------------------

  instance cmdDisp: Svc.CommandDispatcher base id 0x0100 \
    queue size Default.QUEUE_SIZE\
    stack size Default.STACK_SIZE \
    priority 101

  instance comQueue: Svc.ComQueue base id 0x0200 \
    queue size Default.QUEUE_SIZE \
    stack size Default.STACK_SIZE \
    priority 100 \

  instance eventLogger: Svc.ActiveLogger base id 0x0300 \
    queue size Default.QUEUE_SIZE \
    stack size Default.STACK_SIZE \
    priority 98

  instance tlmSend: Svc.TlmChan base id 0x0400 \
    queue size Default.QUEUE_SIZE \
    stack size Default.STACK_SIZE \
    priority 97
{% if cookiecutter.file_system_type in ["SD_Card", "MicroFS"] %}
  instance fileDownlink: Svc.FileDownlink base id 0x0700 \
    queue size 30 \
    stack size Default.STACK_SIZE \
    priority 100

  instance fileManager: Svc.FileManager base id 0x0800 \
    queue size 30 \
    stack size Default.STACK_SIZE \
    priority 100

  instance fileUplink: Svc.FileUplink base id 0x0900 \
    queue size 30 \
    stack size Default.STACK_SIZE \
    priority 100

  instance prmDb: Svc.PrmDb base id 0x0D00 \
    queue size Default.QUEUE_SIZE \
    stack size Default.STACK_SIZE \
    priority 62
{%- endif %}

  # ----------------------------------------------------------------------
  # Queued component instances
  # ----------------------------------------------------------------------

  # ----------------------------------------------------------------------
  # Passive component instances
  # ----------------------------------------------------------------------

  instance rateGroup1: Svc.PassiveRateGroup base id 0x1000

  instance bufferManager: Svc.BufferManager base id 0x2000

  @ Communications driver. May be swapped with other com drivers like Arduino.StreamDriver, Arduino.TcpServer, or Arduino.TcpClient.
{%- if cookiecutter.com_driver_type == "UART" %}
  instance commDriver: Arduino.StreamDriver base id 0x4000
{%- else %}
  instance commDriver: Arduino.{{cookiecutter.com_driver_type}} base id 0x4000
{%- endif %}

  instance framer: Svc.FprimeFramer base id 0x4100

  instance fatalHandler: Baremetal.FatalHandler base id 0x4300

  instance timeHandler: Arduino.ArduinoTime base id 0x4400

  instance rateGroupDriver: Svc.RateGroupDriver base id 0x4500

  instance textLogger: Svc.PassiveTextLogger base id 0x4600

  instance deframer: Svc.FprimeDeframer base id 0x4700

  instance systemResources: Svc.SystemResources base id 0x4800

  instance rateDriver: Arduino.HardwareRateDriver base id 0x4900

  instance comStub: Svc.ComStub base id 0x4B00

  instance frameAccumulator: Svc.FrameAccumulator base id 0x4D00

  instance fprimeRouter: Svc.FprimeRouter base id 0x4E00

}
