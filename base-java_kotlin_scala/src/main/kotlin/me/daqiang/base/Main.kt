package me.daqiang.base

import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking

/**
 * @author daqiang
 *
 * date 2022/1/24 time 16:29
 **/
class Main

fun main() = runBlocking {
    launch { doWorld() }
    println("Hello ${Thread.currentThread()} ")
}

suspend fun doWorld() {
    delay(1000L)
    println("World! ${Thread.currentThread()}")
}