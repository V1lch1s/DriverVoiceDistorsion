#ifndef AUDIO_FILTER_H
#define AUDIO_FILTER_H

#include <ntddk.h>
#include <wdf.h>
#include <portcls.h>
#include <dmusicks.h>

// GUID del driver de filtro (debes generar tu propio GUID)
// {12345678-1234-1234-1234-123456789ABC}
DEFINE_GUID(CLSID_AudioFilter, 
0x12345678, 0x1234, 0x1234, 0x12, 0x34, 0x12, 0x34, 0x56, 0x78, 0x9A, 0xBC);

// Declaración de la función DriverEntry
extern "C" NTSTATUS DriverEntry(
    _In_ PDRIVER_OBJECT DriverObject,
    _In_ PUNICODE_STRING RegistryPath
);

// Declaración de la función EvtDeviceAdd
NTSTATUS EvtDeviceAdd(
    _In_ WDFDRIVER Driver,
    _Inout_ PWDFDEVICE_INIT DeviceInit
);

// Declaración de la función ProcessAudioData
NTSTATUS ProcessAudioData(
    _Inout_ PVOID AudioBuffer,
    _In_ ULONG BufferSize
);

// Declaración de la función OnProcessBuffer
NTSTATUS OnProcessBuffer(
    _In_ PVOID Context,
    _Inout_ PVOID AudioBuffer,
    _In_ ULONG BufferSize
);

#endif // AUDIO_FILTER_H
