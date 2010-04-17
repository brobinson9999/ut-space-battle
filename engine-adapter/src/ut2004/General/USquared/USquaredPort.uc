class USquaredPort extends Actor dependsOn(InternetLink);

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var InternetLink.IPAddr     Address;
  var int                     Protocol;
  var InternetLink            Socket;
  var USquaredSocketInterface SocketInterface;
  
  var bool                    bAllowIncoming, bAllowOutgoing;
  var array<class<InternetLink> > Protocols;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Initialize()
  {
    Protocols[0] = class'USquaredUDPSocket';
    Protocols[1] = class'USquaredTCPSocket';
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function SetSocketInterface(USquaredSocketInterface NewInterface)
  {
    SocketInterface = NewInterface;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function SetPort(int Port)
  {
    Address.Port = Port;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function SetProtocol(int NewProtocol)
  {
    local int Port;
    
    if (NewProtocol < 0 || NewProtocol > Protocols.Length || Protocols[NewProtocol] == None)
      return;
  
    Protocol = NewProtocol;
    
    if (Socket != None)
      Socket.Destroy();
      
    Socket = Spawn(Protocols[Protocol]);
    
    if (Socket != None)
    {
      Port = Address.Port;
      Socket.StringToIpAddr ("127.0.0.1", Address);
//      Socket.GetLocalIP(Address);
      Address.Port = Port;

      if (USquaredUDPSocket(Socket) != None)
        USquaredUDPSocket(Socket).SetPort(Self);
      else if (USquaredTCPSocket(Socket) != None)
        USquaredTCPSocket(Socket).SetPort(Self);
    }
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function SetAsIncoming()
  {
    bAllowIncoming = true;
    bAllowOutgoing = false;

    BindPort();
  }
  
  simulated function SetAsOutgoing()
  {
    bAllowIncoming = false;
    bAllowOutgoing = true;

    BindPort();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function BindPort()
  {
    local int Result;
    
    if (Socket != None)
    {
      if (USquaredUDPSocket(Socket) != None)
        Result = USquaredUDPSocket(Socket).BindPort(Address.Port);
      else if (USquaredTCPSocket(Socket) != None)
        Result = USquaredTCPSocket(Socket).BindPort(Address.Port);
    }
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Send(string Data)
  {
    local bool Result;
    
    if (Socket != None)
    {
      if (USquaredUDPSocket(Socket) != None)
      {
        Result = USquaredUDPSocket(Socket).SendText(Address, Data);
      }
//      else if (USquaredTCPSocket(Socket) != None)
//        Result = USquaredTCPSocket(Socket).SendText(Data);
    }
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function string Receive()
  {
    local string NewData;
    local InternetLink.IPAddr Source;
    local int BytesRead;
    
    if (Socket != None)
    {
      if (USquaredUDPSocket(Socket) != None)
        BytesRead = USquaredUDPSocket(Socket).ReadText(Source, NewData);
//      else if (USquaredTCPSocket(Socket) != None)
//        BytesRead = USquaredTCPSocket(Socket).ReadText(Source, NewData);

      return NewData;
    }
    
    return "";
  }
  
  simulated function ReceivedData(string Data)
  {
    if (SocketInterface != None)
      SocketInterface.Receive(Data);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  bHidden=true
}
