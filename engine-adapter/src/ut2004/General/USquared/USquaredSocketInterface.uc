class USquaredSocketInterface extends BaseActor dependsOn(InternetLink);

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var InternetLink.IPAddr     LocalAddress, RemoteAddress;
  var USquaredPort            IncomingPort, OutgoingPort;
  
  var string                  ReceivedData;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Initialize()
  {
    SetupLink(21544, 21543);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function SetupLink(int LocalPort, int RemotePort)
  {
    IncomingPort = Spawn(class'USquaredPort');
    OutgoingPort = Spawn(class'USquaredPort');
    
    IncomingPort.Initialize();
    OutgoingPort.Initialize();
    
    IncomingPort.SetSocketInterface(Self);
    OutgoingPort.SetSocketInterface(Self);
    
    IncomingPort.SetPort(LocalPort);
    OutgoingPort.SetPort(RemotePort);

    IncomingPort.SetProtocol(0);
    OutgoingPort.SetProtocol(0);
    
    IncomingPort.SetAsIncoming();
    OutgoingPort.SetAsOutgoing();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Send(coerce string Data)
  {
    if (OutgoingPort != None)
    {
      OutgoingPort.Send(Data);
    }
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Tick(float Delta)
  {
    PollReceive();
  }
  
  simulated function PollReceive()
  {
    local string NewData;
    
    if (IncomingPort != None)
    {
      NewData = IncomingPort.Receive();
      if (NewData != "")
      {
        Receive(NewData);
      }
    }
  }
  
  simulated function Receive(string Data)
  {
    ReceivedData = ReceivedData $ Data;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
